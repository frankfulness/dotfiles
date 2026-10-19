#!/usr/bin/env python3
"""Fit the managed top gap below SketchyBar without double-counting the notch."""
from datetime import datetime
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


def fit_top_gap(config, bar_config, screens):
    height = re.search(r"^\s*height=(\d+)\s*$", bar_config, re.M)
    offset = re.search(r"^\s*y_offset=(\d+)\s*$", bar_config, re.M)
    if not height or not offset:
        raise ValueError("Cannot determine SketchyBar height and vertical offset")
    # Leave 10 px below the floating bar. AeroSpace already reserves notch space.
    desired_top = int(height[1]) + int(offset[1]) + 10
    rules = []
    for screen in screens:
        inset = int(screen["top"])
        if inset > 0:
            pattern = "^" + re.escape(screen["name"]) + "$"
            rules.append("{ monitor." + json.dumps(pattern) + " = " + str(max(0, desired_top - inset)) + " }")
    value = "[" + ", ".join(rules + [str(desired_top)]) + "]" if rules else str(desired_top)
    result, count = re.subn(
        r"^outer\.top\s*=.*$",
        lambda _: "outer.top = " + value + " # SketchyBar clearance; display safe area already reserved",
        config, count=1, flags=re.M,
    )
    if count != 1:
        raise ValueError("Cannot find the managed AeroSpace outer.top setting")
    return result


def main():
    home = Path.home()
    config = home / ".config/aerospace/aerospace.toml"
    bar = home / ".config/sketchybar/sketchybarrc"
    if not config.is_file() or not bar.is_file() or config.is_symlink():
        print("Top-gap fitting skipped: expected regular managed desktop configs.")
        return
    script = '''
ObjC.import("AppKit");
var screens = $.NSScreen.screens, result = [];
for (var i = 0; i < screens.count; i++) {
  var screen = screens.objectAtIndex(i);
  result.push({name: ObjC.unwrap(screen.localizedName), top: screen.safeAreaInsets.top});
}
JSON.stringify(result);
'''
    try:
        output = subprocess.check_output(
            ["osascript", "-l", "JavaScript", "-e", script],
            text=True, stderr=subprocess.PIPE, timeout=10,
        )
        screens = json.loads(output)
        if not screens:
            raise ValueError("No screen information available")
        old = config.read_text()
        new = fit_top_gap(old, bar.read_text(), screens)
    except (subprocess.SubprocessError, ValueError, KeyError) as error:
        print("Top-gap fitting skipped:", type(error).__name__)
        return
    if new == old:
        print("AeroSpace top gap already fits SketchyBar and this display.")
        return
    backup = home / ".local/state/dotfiles/backups" / datetime.now().strftime("layout-%Y%m%d-%H%M%S-%f")
    backup.mkdir(parents=True, mode=0o700)
    shutil.copy2(config, backup / "aerospace.toml")
    fd, temporary = tempfile.mkstemp(prefix=".aerospace-", dir=str(config.parent))
    try:
        with os.fdopen(fd, "w") as stream:
            stream.write(new)
        os.chmod(temporary, config.stat().st_mode & 0o777)
        os.replace(temporary, config)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)
    print("Fitted AeroSpace top gap to SketchyBar; prior config saved in", backup)


if __name__ == "__main__":
    main()
