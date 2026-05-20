#!/bin/bash
# One-liner bootstrap: curl -fsSL https://raw.githubusercontent.com/azwarnaim/antigravity-dark-islands/main/bootstrap.sh | bash
set -e
TMPDIR=$(mktemp -d)
git clone https://github.com/azwarnaim/antigravity-dark-islands "$TMPDIR/antigravity-dark-islands"
bash "$TMPDIR/antigravity-dark-islands/install.sh"
rm -rf "$TMPDIR"
