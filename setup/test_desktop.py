#!/usr/bin/env python3
"""Offline tests: no actual brew installs/trust, app launches, or services."""
import contextlib
import io
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

import configure
import test_setup


class DesktopTests(unittest.TestCase):
    def deploy(self, home, **options):
        with contextlib.redirect_stdout(io.StringIO()):
            configure.deploy(home, **options)

    def test_desktop_copies_scripts_font_and_skips_backup_files(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            self.deploy(home, desktop=True)
            for name in (
                ".config/aerospace/aerospace.toml",
                ".config/sketchybar/sketchybarrc",
                ".config/sketchybar/helpers/icon_map.sh",
                ".config/borders/bordersrc",
                "Library/Fonts/sketchybar-app-font.ttf",
            ):
                self.assertTrue((home / name).is_file(), name)
            for name in (
                ".config/sketchybar/sketchybarrc",
                ".config/sketchybar/plugins/spotify.sh",
                ".config/borders/bordersrc",
            ):
                self.assertEqual((home / name).stat().st_mode & 0o777, 0o755)
            self.assertFalse(list((home / ".config/sketchybar").rglob("*backup*")))
            before = {p: p.stat().st_mtime_ns for p in home.rglob("*") if p.is_file()}
            self.deploy(home, desktop=True)
            self.assertEqual(before, {p: p.stat().st_mtime_ns for p in home.rglob("*") if p.is_file()})

    def test_conflicting_root_config_and_old_symlink_are_backed_up(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp) / "home"
            external = Path(temp) / "old-checkout"
            external.mkdir()
            (external / "sketchybarrc").write_text("original external content")
            (home / ".config").mkdir(parents=True)
            (home / ".config/sketchybar").symlink_to(external)
            (home / ".aerospace.toml").write_text("# old root config")
            self.deploy(home, desktop=True)
            self.assertFalse((home / ".aerospace.toml").exists())
            self.assertFalse((home / ".config/sketchybar").is_symlink())
            self.assertEqual((external / "sketchybarrc").read_text(), "original external content")
            backups = list((home / ".local/state/dotfiles/backups").iterdir())
            self.assertEqual(len(backups), 1)
            self.assertEqual((backups[0] / ".aerospace.toml").read_text(), "# old root config")
            self.assertTrue((backups[0] / ".config/sketchybar").is_symlink())

    def test_warp_phase_changes_only_warp_and_disables_attribution(self):
        try:
            import tomllib
        except ImportError:
            self.skipTest("TOML validation requires Python 3.11+")
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            self.deploy(home, desktop=True, phase="warp")
            self.assertEqual({p.name for p in home.iterdir()}, {".warp"})
            settings = tomllib.loads((home / ".warp/settings.toml").read_text())
            self.assertFalse(settings["agents"]["warp_agent"]["other"]["agent_attribution_enabled"])

    def test_desktop_manifest_is_scoped_and_keeps_existing_aerospace(self):
        fixture = test_setup.SetupTests()
        entries, _ = fixture.brew_entries("setup/Brewfile.desktop")
        self.assertIn("felixkratz/formulae/borders", entries["brew"])
        self.assertIn("felixkratz/formulae/sketchybar", entries["brew"])
        self.assertIn("jq", entries["brew"])
        self.assertEqual(entries["cask"], ["nikitabobko/tap/aerospace"])
        entries, output = fixture.brew_entries(
            "setup/Brewfile.desktop", user_apps=("AeroSpace",),
        )
        self.assertEqual(entries["cask"], [])
        self.assertIn("Skipping AeroSpace:", output)

    def test_early_shell_backs_up_and_is_repeatable_without_homebrew(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            (home / ".zshrc").write_text("# original")
            env = dict(os.environ, HOME=str(home), PATH="/usr/bin:/bin:/usr/sbin:/sbin")
            command = ["/bin/bash", str(configure.ROOT / "setup/early-shell.sh")]
            subprocess.run(command, env=env, capture_output=True, check=True, timeout=15)
            self.assertEqual((home / ".zshrc").read_bytes(), (configure.ROOT / ".zshrc").read_bytes())
            self.assertTrue((home / "Desktop/PARA/4-archive/prior-interest").is_dir())
            backups = list((home / ".local/state/dotfiles/backups").iterdir())
            self.assertEqual((backups[0] / ".zshrc").read_text(), "# original")
            self.assertEqual(backups[0].stat().st_mode & 0o777, 0o700)
            before = (home / ".zshrc").stat().st_mtime_ns
            subprocess.run(command, env=env, capture_output=True, check=True, timeout=15)
            self.assertEqual((home / ".zshrc").stat().st_mtime_ns, before)
            self.assertEqual(len(list((home / ".local/state/dotfiles/backups").iterdir())), 1)

    def test_full_desktop_dry_run_writes_nothing(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            result = subprocess.run(
                ["/bin/bash", str(configure.ROOT / "install.sh"),
                 "--desktop-only", "--dry-run", "--non-interactive"],
                env=dict(os.environ, HOME=str(home), NVM_DIR=str(home / ".nvm")),
                capture_output=True, text=True, stdin=subprocess.DEVNULL, timeout=30,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(list(home.iterdir()), [])
            self.assertNotIn('--file=' + str(configure.ROOT / "setup/Brewfile.apps"), result.stdout)
            self.assertIn("brew trust --formula felixkratz/formulae/borders", result.stdout)
            self.assertLess(result.stdout.index("Copy .zshrc"), result.stdout.index("Homebrew shell tools"))
            self.assertLess(result.stdout.index("Warp customization"), result.stdout.index("Desktop dependencies"))

    def run_stubbed_installer(self, home, trust_available=True, fail_shell=False, desktop_only=True):
        bin_dir = home / ".local/bin"
        bin_dir.mkdir(parents=True)
        log = home / "commands.log"

        def stub(name, body):
            path = bin_dir / name
            path.write_text("#!/bin/bash\n" + body)
            path.chmod(0o755)

        stub("brew", '''
printf 'brew %s\\n' "$*" >> "$TEST_LOG"
if [ "$1" = help ]; then exit "$TEST_TRUST_STATUS"; fi
if [ "$1" = bundle ]; then
    test -f "$HOME/.zshrc" || exit 91
    test -d "$HOME/Desktop/PARA/4-archive/prior-interest" || exit 92
    case "$*" in
        *Brewfile.shell*) if [ "$TEST_FAIL_SHELL" = 1 ]; then exit 42; fi ;;
        *Brewfile.warp*|*Brewfile.apps*) test -f "$HOME/.warp/settings.toml" || exit 93 ;;
    esac
fi
''')
        stub("xcode-select", "exit 0\n")
        stub("open", 'printf "open %s\\n" "$*" >> "$TEST_LOG"\n')
        stub("aerospace", '''
printf 'aerospace %s\\n' "$*" >> "$TEST_LOG"
test -f "$HOME/.config/aerospace/aerospace.toml" || exit 94
''')
        stub("sketchybar", 'printf "sketchybar %s\\n" "$*" >> "$TEST_LOG"\n')
        stub("borders", "exit 0\n")
        (home / ".oh-my-zsh").mkdir()
        (home / ".nvm").mkdir()
        (home / ".nvm/nvm.sh").write_text(
            'nvm() { printf "nvm %s\\n" "$*" >> "$TEST_LOG"; }\n'
        )
        env = dict(
            os.environ, HOME=str(home), NVM_DIR=str(home / ".nvm"),
            PATH=str(bin_dir) + ":" + os.environ["PATH"], TEST_LOG=str(log),
            TEST_TRUST_STATUS="0" if trust_available else "1",
            TEST_FAIL_SHELL="1" if fail_shell else "0",
            PYTHONDONTWRITEBYTECODE="1",
        )
        command = ["/bin/bash", str(configure.ROOT / "install.sh"),
                   "--non-interactive", "--skip-extensions"]
        if desktop_only:
            command.append("--desktop-only")
        result = subprocess.run(
            command,
            env=env, text=True, capture_output=True,
            stdin=subprocess.DEVNULL, timeout=30,
        )
        return result, log.read_text()

    def test_mocked_install_trust_install_copy_then_start(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            result, log = self.run_stubbed_installer(home)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertLess(log.index("trust --formula felixkratz/formulae/sketchybar"),
                            log.index("--file=" + str(configure.ROOT / "setup/Brewfile.desktop")))
            self.assertLess(log.index("trust --formula felixkratz/formulae/borders"),
                            log.index("services restart felixkratz/formulae/borders"))
            self.assertLess(log.index("aerospace reload-config"),
                            log.index("services restart felixkratz/formulae/sketchybar"))
            self.assertNotIn("brew trust felixkratz/formulae", log)
            self.assertNotIn("Brewfile.apps", log)

    def test_default_install_orders_shell_then_warp_then_apps(self):
        with tempfile.TemporaryDirectory() as temp:
            result, log = self.run_stubbed_installer(Path(temp), desktop_only=False)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertLess(log.index("Brewfile.shell"), log.index("Brewfile.warp"))
            self.assertLess(log.index("Brewfile.warp"), log.index("Brewfile.apps"))
            self.assertNotIn("services restart", log)

    def test_config_only_desktop_copies_without_services_or_downloads(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            result = subprocess.run(
                ["/bin/bash", str(configure.ROOT / "install.sh"),
                 "--config-only", "--desktop", "--non-interactive"],
                env=dict(os.environ, HOME=str(home)), capture_output=True, text=True,
                stdin=subprocess.DEVNULL, timeout=30,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertTrue((home / ".config/sketchybar/sketchybarrc").is_file())
            self.assertNotIn("brew bundle", result.stdout)
            self.assertNotIn("services restart", result.stdout)
            self.assertTrue(os.access(home / ".config/borders/bordersrc", os.X_OK))

    def test_older_homebrew_without_trust_still_installs(self):
        with tempfile.TemporaryDirectory() as temp:
            result, log = self.run_stubbed_installer(Path(temp), trust_available=False)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertNotIn("brew trust ", log)
            self.assertIn("Brewfile.desktop", log)

    def test_failed_download_leaves_shell_and_para_ready(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            result, log = self.run_stubbed_installer(home, fail_shell=True)
            self.assertEqual(result.returncode, 42)
            self.assertTrue((home / ".zshrc").is_file())
            self.assertTrue((home / "Desktop/PARA/1-projects").is_dir())
            self.assertFalse((home / ".warp").exists())
            self.assertNotIn("Brewfile.apps", log)


if __name__ == "__main__":
    unittest.main()
