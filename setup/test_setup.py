#!/usr/bin/env python3
"""Offline tests: only temporary homes are modified, never the real user home."""
import contextlib
import importlib.util
import io
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

import configure

SPEC = importlib.util.spec_from_file_location("check_public", Path(__file__).with_name("check-public.py"))
PUBLIC = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(PUBLIC)


class SetupTests(unittest.TestCase):
    def brew_entries(self, manifest, system_apps=(), user_apps=(), broken_links=()):
        # Evaluate only the Brewfile DSL, not Homebrew. System app lookups are
        # redirected into a fixture so this Mac's real apps cannot affect tests.
        harness = r'''
require "json"
[:exist?, :symlink?].each do |method|
  original = File.method(method)
  File.define_singleton_method(method) do |path|
    fixture = path.start_with?("/Applications/") ?
      ENV.fetch("TEST_SYSTEM_APPS") + path.delete_prefix("/Applications") : path
    original.call(fixture)
  end
end
entries = {"brew" => [], "cask" => [], "mas" => []}
context = Object.new
entries.each_key do |kind|
  context.define_singleton_method(kind) { |name, *options| entries[kind] << name }
end
context.instance_eval(File.read(ARGV.fetch(0)), ARGV.fetch(0))
puts "RESULT=" + JSON.generate(entries)
'''
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            system = home / "system-applications"
            user = home / "Applications"
            system.mkdir()
            user.mkdir()
            for folder, names in ((system, system_apps), (user, user_apps)):
                for name in names:
                    (folder / (name + ".app")).mkdir()
            for name in broken_links:
                (system / (name + ".app")).symlink_to(home / "missing-app")
            result = subprocess.run(
                ["/usr/bin/ruby", "-e", harness, str(configure.ROOT / manifest)],
                env=dict(os.environ, HOME=str(home), TEST_SYSTEM_APPS=str(system)),
                capture_output=True, text=True, check=True, timeout=15,
            )
            return json.loads(result.stdout.split("RESULT=")[-1]), result.stdout

    def test_fresh_mac_requests_all_apps(self):
        entries, _ = self.brew_entries("Brewfile")
        self.assertEqual(len(entries["cask"]), 17)  # 15 apps and two fonts.
        self.assertIn("warp", entries["cask"])
        self.assertIn("visual-studio-code", entries["cask"])

    def test_existing_system_and_user_apps_and_symlinks_are_skipped(self):
        entries, output = self.brew_entries(
            "Brewfile", system_apps=("Warp",),
            user_apps=("Visual Studio Code",), broken_links=("Slack",),
        )
        for token in ("warp", "visual-studio-code", "slack"):
            self.assertNotIn(token, entries["cask"])
        self.assertIn("claude", entries["cask"])
        self.assertIn("Skipping Warp:", output)
        self.assertIn("Skipping Visual Studio Code:", output)
        self.assertIn("Skipping Slack:", output)

    def test_all_existing_apps_leave_only_font_casks(self):
        apps = (
            "Warp", "Claude", "Docker", "Figma", "Slack", "zoom.us",
            "Obsidian", "Google Chrome", "Visual Studio Code", "Bruno",
            "Clipy", "Screen Studio", "Raycast", "Affinity", "Spotify",
        )
        entries, _ = self.brew_entries("Brewfile", system_apps=apps)
        self.assertEqual(entries["cask"], ["font-0xproto-nerd-font", "font-hack"])
        self.assertIn("git", entries["brew"])

    def test_app_store_only_requests_missing_apps(self):
        entries, _ = self.brew_entries("setup/Brewfile.app-store")
        self.assertEqual(entries["mas"], ["Dato", "Cursor Pro", "Keystroke Pro"])
        entries, _ = self.brew_entries(
            "setup/Brewfile.app-store", system_apps=("Dato",),
            user_apps=("Cursor Pro",), broken_links=("Keystroke Pro",),
        )
        self.assertEqual(entries["mas"], [])

    def deploy(self, home, **kwargs):
        with contextlib.redirect_stdout(io.StringIO()):
            configure.deploy(home, **kwargs)

    def git_value(self, path, key):
        return subprocess.check_output(
            ["git", "config", "--file", str(path), "--get", key], text=True
        ).strip()

    def test_dry_run_creates_nothing(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp) / "new home"
            self.deploy(home, dry_run=True)
            self.assertFalse(home.exists())

    def test_repeatable_fresh_install_and_para(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp) / "home with spaces"
            self.deploy(home)
            before = {p: p.stat().st_mtime_ns for p in home.rglob("*") if p.is_file()}
            self.deploy(home)
            self.assertEqual(before, {p: p.stat().st_mtime_ns for p in home.rglob("*") if p.is_file()})
            self.assertFalse((home / ".local/state/dotfiles/backups").exists())
            actual = {
                str(p.relative_to(home / "Desktop/PARA"))
                for p in (home / "Desktop/PARA").rglob("*")
            }
            self.assertEqual(actual, set(configure.PARA_DIRS))
            settings = (home / ".warp/settings.toml").read_text()
            self.assertNotIn("@CUSTOM_THEME@", settings)
            self.assertIn(str(home), settings)
            self.assertFalse((home / ".zshrc").is_symlink())
            self.assertFalse((home / ".gitconfig.local").exists())

    def test_backup_and_private_overrides_preserved(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            (home / ".zshrc").write_text("# old local configuration\n")
            local = b"# private overrides\n"
            (home / ".zshrc.local").write_bytes(local)
            (home / ".gitconfig.local").write_bytes(local)
            self.deploy(home)
            self.assertEqual((home / ".zshrc.local").read_bytes(), local)
            self.assertEqual((home / ".gitconfig.local").read_bytes(), local)
            backups = list((home / ".local/state/dotfiles/backups").iterdir())
            self.assertEqual(len(backups), 1)
            self.assertEqual(backups[0].stat().st_mode & 0o777, 0o700)
            self.assertEqual((backups[0] / ".zshrc").read_text(), "# old local configuration\n")

    def test_git_migration_keeps_identity_and_signing_private(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            (home / ".gitconfig").write_text(
                "[user]\nname = Example Author\nemail = example@example.com\n"
                "signingkey = EXAMPLE_PUBLIC_FINGERPRINT\n[commit]\ngpgsign = true\n"
                "[include]\npath = ~/.gitconfig.local\n"
            )
            self.deploy(home)
            private = home / ".gitconfig.local"
            self.assertEqual(self.git_value(private, "user.name"), "Example Author")
            self.assertEqual(self.git_value(private, "commit.gpgsign"), "true")
            self.assertNotIn("include.path", private.read_text())
            self.assertEqual(private.stat().st_mode & 0o777, 0o600)
            self.assertNotIn("Example Author", (home / ".gitconfig").read_text())

    def test_existing_symlink_is_backed_up_not_followed(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            original = home / "original"
            original.write_text("keep me")
            (home / ".zshrc").symlink_to(original)
            self.deploy(home)
            self.assertEqual(original.read_text(), "keep me")
            self.assertFalse((home / ".zshrc").is_symlink())

    def test_templates_and_json_parse(self):
        # Python >=3.11 provides an independent TOML parser with no dependencies.
        try:
            import tomllib
        except ImportError:
            self.skipTest("TOML validation requires Python 3.11+")
        root = configure.ROOT
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp) / 'home "with quotes"'
            self.deploy(home)
            settings = tomllib.loads((home / ".warp/settings.toml").read_text())
            theme = settings["appearance"]["themes"]["theme"]["custom"]["path"]
            self.assertEqual(theme, str(home.resolve() / ".warp/themes/custom/custom.yaml"))
        for path in (root / "warp/tab_configs").glob("*.toml"):
            config = tomllib.loads(path.read_text())
            self.assertTrue(config["name"])
            self.assertEqual(len(config["panes"]), 1)
            self.assertIn(config["panes"][0]["type"], ("agent", "terminal"))
        tomllib.loads((root / "starship.toml").read_text())
        json.loads((root / "vscode/settings.json").read_text())

    def test_credential_checker_detects_without_echoing(self):
        candidate = "ghp_" + "A" * 36
        self.assertTrue(list(PUBLIC.findings(candidate)))
        self.assertFalse(list(PUBLIC.findings('export API_KEY="$KEYCHAIN_VALUE"')))

    def test_missing_source_fails_before_writing(self):
        with tempfile.TemporaryDirectory() as temp:
            original = configure.ROOT
            try:
                configure.ROOT = Path(temp) / "empty repository"
                home = Path(temp) / "new home"
                with self.assertRaises(FileNotFoundError):
                    self.deploy(home)
                self.assertFalse(home.exists())
            finally:
                configure.ROOT = original

    def test_installer_config_only_runs_in_temporary_home(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            env = dict(os.environ, HOME=str(home), PYTHONDONTWRITEBYTECODE="1")
            result = subprocess.run(
                ["/bin/bash", str(configure.ROOT / "install.sh"), "--config-only"],
                env=env, text=True, capture_output=True,
                stdin=subprocess.DEVNULL, timeout=30,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertTrue((home / ".zshrc").is_file())
            self.assertFalse((home / ".nvm").exists())
            self.assertFalse((home / ".oh-my-zsh").exists())

    def test_installer_help_and_unknown_option(self):
        script = str(configure.ROOT / "install.sh")
        result = subprocess.run(
            ["/bin/bash", script, "--help"], capture_output=True, text=True,
        )
        self.assertEqual(result.returncode, 0)
        self.assertIn("--dry-run", result.stdout)
        invalid = subprocess.run(
            ["/bin/bash", script, "--not-a-real-option"], capture_output=True,
        )
        self.assertEqual(invalid.returncode, 2)


if __name__ == "__main__":
    unittest.main()
