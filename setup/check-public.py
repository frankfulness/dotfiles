#!/usr/bin/env python3
"""Heuristic credential/privacy check. Reports locations, never matched values."""
import argparse
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
PATTERNS = {
    "private-key": r"-----BEGIN (?:RSA |EC |OPENSSH |DSA |PGP )?PRIVATE KEY",
    "github-token": r"\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,})",
    "aws-access-key": r"\b(?:AKIA|ASIA)[A-Z0-9]{16}\b",
    "anthropic-key": r"\bsk-ant-[A-Za-z0-9_-]{30,}",
    "openai-key": r"\bsk-(?:proj-)?[A-Za-z0-9_-]{40,}",
    "slack-token": r"\bxox[baprs]-[A-Za-z0-9-]{20,}",
    "jwt": r"\beyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}",
    "credential-in-url": r"https?://[^/\s:@]+:[^/\s@]+@",
    "machine-home": r"/Users/[A-Za-z0-9][A-Za-z0-9_.-]*/",
    "literal-credential": r"""(?im)^\s*(?:export\s+)?[A-Za-z_]*(?:API_KEY|ACCESS_TOKEN|AUTH_TOKEN|CLIENT_SECRET|PASSWORD)\s*=\s*["']?[A-Za-z0-9_+/=-]{16,}""",
}


def findings(text):
    for number, line in enumerate(text.splitlines(), 1):
        for name, pattern in PATTERNS.items():
            if re.search(pattern, line):
                yield number, name


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--history", action="store_true", help="Also inspect reachable Git history")
    args = parser.parse_args()
    paths = subprocess.check_output(
        ["git", "-C", str(ROOT), "ls-files", "-z", "--cached", "--others", "--exclude-standard"]
    ).split(b"\0")
    count = 0
    for raw in paths:
        if not raw:
            continue
        relative = raw.decode()
        path = ROOT / relative
        if not path.is_file() or path.is_symlink():
            continue
        data = path.read_bytes()
        if b"\0" in data:
            continue
        for line, name in findings(data.decode("utf-8", errors="replace")):
            print(f"{relative}:{line}: {name} (value withheld)")
            count += 1
    if args.history:
        refs = subprocess.check_output(["git", "-C", str(ROOT), "rev-list", "--all"], text=True).splitlines()
        for ref in refs:
            text = subprocess.check_output(
                ["git", "-C", str(ROOT), "show", "--format=", "--no-ext-diff", ref],
                text=True, errors="replace",
            )
            for line, name in findings(text):
                # Old machine paths are not credentials; retain credential checks.
                if name != "machine-home":
                    print(f"history {ref[:12]} diff-line {line}: {name} (value withheld)")
                    count += 1
    print(f"Public-file check: {count} potential issue(s). This is not a security guarantee.")
    return 1 if count else 0


if __name__ == "__main__":
    sys.exit(main())
