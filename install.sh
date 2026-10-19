#!/bin/bash
# Ordered macOS bootstrap; all implementation lives under setup/.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec /bin/bash "$ROOT/setup/bootstrap.sh" "$@"
