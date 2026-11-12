#!/bin/sh
set -eu
PROJECT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CHECK_FILE=$(mktemp /tmp/moonlit-model-check.XXXXXX.swift)
trap 'rm -f "$CHECK_FILE"' EXIT
cat "$PROJECT_DIR/iosHw5/Models/Poem.swift" "$PROJECT_DIR/Verification/ModelChecks.swift" > "$CHECK_FILE"
swift -module-cache-path /tmp/moon-module-cache "$CHECK_FILE"
