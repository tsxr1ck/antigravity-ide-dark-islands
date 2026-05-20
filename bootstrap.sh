#!/bin/bash
# One-liner bootstrap: curl -fsSL https://raw.githubusercontent.com/tsxr1ck/antigravity-ide-dark-islands/main/bootstrap.sh | bash
set -e
TMPDIR=$(mktemp -d)
git clone https://github.com/tsxr1ck/antigravity-ide-dark-islands "$TMPDIR/antigravity-ide-dark-islands"
bash "$TMPDIR/antigravity-ide-dark-islands/install.sh"
rm -rf "$TMPDIR"
