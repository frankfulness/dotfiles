#!/usr/bin/env python3
"""Deploy reviewed files only; never import app state or credentials."""
import argparse
from datetime import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
PARA_DIRS = (
    "0-index", "1-projects", "2-areas", "3-resources", "4-archive",
    "4-archive/completed-projects", "4-archive/finished-tasks",
    "4-archive/inactive-area", "4-archive/prior-interest",
)


def deploy(home, dry_run=False, interactive=False, desktop=False, phase="all"):
    if phase not in ("all", "warp", "remaining"):
        raise ValueError("Unknown configuration phase: " + phase)
    home = home.resolve()
    backup = home / ".local/state/dotfiles/backups" / datetime.now().strftime("%Y%m%d-%H%M%S-%f")
    targets = [
        (".zshrc", ".zshrc"), (".zprofile", ".zprofile"),
        (".gitconfig", ".gitconfig"), ("starship.toml", ".config/starship.toml"),
        ("git/ignore", ".config/git/ignore"),
        ("warp/settings.toml.template", ".warp/settings.toml"),
        ("warp/keybindings.yaml", ".warp/keybindings.yaml"),
        ("warp/themes/custom/custom.yaml", ".warp/themes/custom/custom.yaml"),
        ("warp/themes/custom/custom.png", ".warp/themes/custom/custom.png"),
        ("warp/tab_configs/default.toml", ".warp/tab_configs/default.toml"),
        ("warp/tab_configs/startup.toml", ".warp/tab_configs/startup.toml"),
        ("warp/launch_configurations/default.yaml.template", ".warp/launch_configurations/default.yaml"),
        ("vscode/settings.json", "Library/Application Support/Code/User/settings.json"),
        ("vscode/keybindings.json", "Library/Application Support/Code/User/keybindings.json"),
    ]
    for source in sorted((ROOT / "vscode/snippets").glob("*")):
        if source.is_file():
            targets.append((str(source.relative_to(ROOT)), "Library/Application Support/Code/User/snippets/" + source.name))

    if phase == "warp":
        targets = [(source, target) for source, target in targets if source.startswith("warp/")]
    elif phase == "remaining":
        targets = [(source, target) for source, target in targets
                   if source not in (".zshrc", ".zprofile", "starship.toml") and not source.startswith("warp/")]
    desktop = desktop and phase != "warp"
    desktop_targets = []
    if desktop:
        for directory in ("aerospace", "sketchybar", "borders"):
            tree = ROOT / directory
            if not tree.is_dir() or tree.is_symlink():
                raise FileNotFoundError("Missing or symlinked desktop source: " + directory)
            for source in sorted(tree.rglob("*")):
                relative = source.relative_to(tree)
                if any(part.startswith(".") or ".backup" in part for part in relative.parts):
                    continue
                if source.is_symlink():
                    raise ValueError("Refusing symlinked source: " + str(source.relative_to(ROOT)))
                if source.is_file():
                    desktop_targets.append((
                        str(source.relative_to(ROOT)),
                        ".config/" + directory + "/" + str(relative),
                    ))
        desktop_targets.append((
            "sketchybar/helpers/sketchybar-app-font.ttf",
            "Library/Fonts/sketchybar-app-font.ttf",
        ))
        targets.extend(desktop_targets)

    def save_existing(relative):
        dest = home / relative
        if not dest.exists() and not dest.is_symlink():
            return
        print(("Would back up: " if dry_run else "Back up: ") + relative)
        if dry_run:
            return
        backup.mkdir(parents=True, exist_ok=True, mode=0o700)
        saved = backup / relative
        saved.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
        shutil.move(str(dest), str(saved))
        print("  Previous file backed up outside the repository.")

    def write(relative, content, mode=0o600):
        dest = home / relative
        if dest.is_file() and not dest.is_symlink() and dest.read_bytes() == content and dest.stat().st_mode & 0o777 == mode:
            print("Unchanged:", relative)
            return
        print(("Would deploy: " if dry_run else "Deploy: ") + relative)
        if dry_run:
            return
        save_existing(relative)
        dest.parent.mkdir(parents=True, exist_ok=True)
        fd, temp = tempfile.mkstemp(prefix=".dotfiles-", dir=str(dest.parent))
        try:
            with os.fdopen(fd, "wb") as stream:
                os.fchmod(stream.fileno(), mode)
                stream.write(content)
            os.replace(temp, dest)
        finally:
            if os.path.exists(temp):
                os.unlink(temp)

    # Fail before writing anything if a repository file is missing.
    for source, _ in targets:
        if not (ROOT / source).is_file():
            raise FileNotFoundError("Missing source: " + source)
    if desktop:
        # AeroSpace reports an ambiguity if both supported config locations exist.
        save_existing(".aerospace.toml")
        # Do not follow desktop-directory symlinks into a previous checkout.
        for _, relative in desktop_targets:
            if not relative.startswith(".config/"):
                continue
            parts = Path(relative).parts
            for length in range(2, len(parts)):
                ancestor = Path(*parts[:length])
                if (home / ancestor).is_symlink():
                    save_existing(str(ancestor))

    local_git = home / ".gitconfig.local"
    current_git = home / ".gitconfig"
    if phase != "warp" and not local_git.exists() and current_git.is_file():
        old = current_git.read_bytes()
        if old != (ROOT / ".gitconfig").read_bytes():
            # Keep the old config private, minus the include that would recurse.
            # git config --null --list emits key\\nvalue\\0 records, never printed.
            result = subprocess.run(
                ["git", "config", "--file", str(current_git), "--null", "--list"],
                check=True, stdout=subprocess.PIPE,
            )
            records = []
            for record in result.stdout.split(b"\0"):
                if not record:
                    continue
                key, _, value = record.partition(b"\n")
                if key.lower() == b"include.path" and value in (
                    b"~/.gitconfig.local", str(local_git).encode(),
                ):
                    continue
                records.append((key.decode(), value.decode()))
            if records:
                print("Preserve existing Git settings privately in ~/.gitconfig.local.")
                if not dry_run:
                    write(".gitconfig.local", b"# Private settings migrated from the previous Git config.\n")
                    for key, value in records:
                        subprocess.run(
                            ["git", "config", "--file", str(local_git), "--add", key, value],
                            check=True,
                        )
                    local_git.chmod(0o600)

    for source, target in targets:
        content = (ROOT / source).read_bytes()
        if source.endswith(".template"):
            # Serialize full paths so unusual usernames remain valid TOML/YAML.
            content = content.decode().replace(
                '"@HOME@"', json.dumps(str(home), ensure_ascii=False)
            ).replace(
                '"@CUSTOM_THEME@"',
                json.dumps(str(home / ".warp/themes/custom/custom.yaml"), ensure_ascii=False),
            ).encode()
        mode = 0o600
        if (source, target) in desktop_targets:
            executable = (ROOT / source).stat().st_mode & 0o111 or source.endswith((".sh", "sketchybarrc", "bordersrc"))
            mode = 0o755 if executable else 0o644
        write(target, content, mode=mode)
    if phase == "warp":
        if not dry_run and backup.exists():
            backup.chmod(0o700)
            print("Backup directory:", backup)
        return
    if phase == "all":
        for relative in PARA_DIRS:
            dest = home / "Desktop/PARA" / relative
            print(("Would create: " if dry_run else "Ensure: ") + "Desktop/PARA/" + relative)
            if not dry_run:
                dest.mkdir(parents=True, exist_ok=True)
    if not local_git.exists():
        if interactive and not dry_run:
            name = input("Git author name (blank to configure later): ").strip()
            email = input("Git author email (blank to configure later): ").strip()
            if name or email:
                write(".gitconfig.local", b"# Private machine-local Git identity.\n")
                for key, value in (("user.name", name), ("user.email", email)):
                    if value:
                        subprocess.run(["git", "config", "--file", str(local_git), key, value], check=True)
                local_git.chmod(0o600)
        else:
            print("Git identity: configure ~/.gitconfig.local; shared settings contain no identity or signing key.")
    if not dry_run and backup.exists():
        backup.chmod(0o700)
        print("Backup directory:", backup)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--non-interactive", action="store_true")
    parser.add_argument("--desktop", action="store_true", help="Also copy AeroSpace, SketchyBar, and JankyBorders")
    parser.add_argument("--phase", choices=("all", "warp", "remaining"), default="all")
    args = parser.parse_args()
    deploy(Path.home(), dry_run=args.dry_run, interactive=not args.non_interactive and os.isatty(0), desktop=args.desktop, phase=args.phase)


if __name__ == "__main__":
    main()
