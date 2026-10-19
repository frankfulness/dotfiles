"""Editor setup tests using temporary homes and a fake VS Code CLI."""
import contextlib
import io
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

import configure
import test_setup


class EditorTests(unittest.TestCase):
    def deploy(self, home, **options):
        with contextlib.redirect_stdout(io.StringIO()):
            configure.deploy(home, **options)

    def test_neovim_is_in_shell_bundle(self):
        entries, _ = test_setup.SetupTests().brew_entries("setup/Brewfile.shell")
        self.assertIn("neovim", entries["brew"])

    def test_neovim_configuration_is_deployed_with_lockfile(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            self.deploy(home)
            for name in ("init.lua", "lazy-lock.json", "lazyvim.json", ".neoconf.json",
                         "stylua.toml", "lua/config/lazy.lua", "lua/plugins/colorscheme.lua"):
                dest = home / ".config/nvim" / name
                self.assertEqual(dest.read_bytes(), (configure.ROOT / "nvim" / name).read_bytes())
            self.assertFalse((home / ".config/nvim/lazy").exists())
            self.assertFalse((home / ".config/nvim/README.md").exists())

    def test_neovim_existing_file_is_backed_up_and_directory_symlink_detached(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp) / "home"
            old = Path(temp) / "old-config"
            old.mkdir()
            (old / "init.lua").write_text("-- keep this original")
            (home / ".config").mkdir(parents=True)
            (home / ".config/nvim").symlink_to(old)
            self.deploy(home)
            self.assertFalse((home / ".config/nvim").is_symlink())
            self.assertEqual((old / "init.lua").read_text(), "-- keep this original")
            (home / ".config/nvim/init.lua").write_text("-- local config")
            self.deploy(home)
            backups = list((home / ".local/state/dotfiles/backups").iterdir())
            self.assertTrue(any((p / ".config/nvim/init.lua").is_file() and
                                (p / ".config/nvim/init.lua").read_text() == "-- local config"
                                for p in backups))

    def fake_code(self, home):
        code = home / "code"
        state = home / "installed.txt"
        state.write_text("")
        log = home / "calls.txt"
        code.write_text('''#!/bin/bash
case "$1" in
    --list-extensions) cat "$TEST_CODE_STATE" ;;
    --install-extension)
        printf '%s\\n' "$2" >> "$TEST_CODE_LOG"
        if [ "$2" = "${TEST_CODE_FAIL:-}" ]; then exit 1; fi
        printf '%s\\n' "$2" >> "$TEST_CODE_STATE"
        ;;
    *) exit 2 ;;
esac
''')
        code.chmod(0o755)
        env = dict(os.environ, HOME=str(home), DOTFILES_VSCODE_CLI=str(code),
                   TEST_CODE_STATE=str(state), TEST_CODE_LOG=str(log),
                   PYTHONDONTWRITEBYTECODE="1")
        return env, state, log

    def vscode(self, env, *options):
        return subprocess.run(
            ["/bin/bash", str(configure.ROOT / "install.sh"), "--vscode-only", *options],
            env=env, capture_output=True, text=True, stdin=subprocess.DEVNULL, timeout=30,
        )

    def desired(self):
        return [s for s in (configure.ROOT / "vscode/extensions.txt").read_text().splitlines()
                if s and not s.startswith("#")]

    def test_vscode_only_installs_missing_extensions_then_skips_them(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            env, state, log = self.fake_code(home)
            state.write_text("ESBENP.PRETTIER-VSCODE\n")
            result = self.vscode(env)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertNotIn("Git identity:", result.stdout)
            calls = log.read_text().splitlines()
            self.assertNotIn("esbenp.prettier-vscode", calls)
            self.assertEqual(set(calls), set(self.desired()) - {"esbenp.prettier-vscode"})
            first = log.read_bytes()
            result = self.vscode(env)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(log.read_bytes(), first)
            self.assertFalse((home / ".zshrc").exists())
            self.assertFalse((home / ".warp").exists())
            self.assertFalse((home / ".config/nvim").exists())
            self.assertFalse((home / ".gitconfig").exists())
            self.assertTrue((home / "Library/Application Support/Code/User/settings.json").is_file())

    def test_vscode_failure_is_reported_and_other_extensions_continue(self):
        with tempfile.TemporaryDirectory() as temp:
            env, _, log = self.fake_code(Path(temp))
            env["TEST_CODE_FAIL"] = "esbenp.prettier-vscode"
            result = self.vscode(env)
            self.assertEqual(result.returncode, 1)
            self.assertIn("Failed to install extension: esbenp.prettier-vscode", result.stderr)
            self.assertIn("vue.volar", log.read_text())

    def test_vscode_config_only_does_not_install_extensions(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            env, _, log = self.fake_code(home)
            result = self.vscode(env, "--config-only")
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertFalse(log.exists())
            self.assertTrue((home / "Library/Application Support/Code/User/keybindings.json").is_file())

    def test_vscode_dry_run_writes_nothing(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            result = self.vscode(dict(os.environ, HOME=str(home)), "--dry-run")
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(list(home.iterdir()), [])
            self.assertIn("Install VS Code extension: jdinhlife.gruvbox", result.stdout)


if __name__ == "__main__":
    unittest.main()
