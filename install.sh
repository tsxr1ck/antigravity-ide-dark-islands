#!/bin/bash

set -e

echo "🏝️  Islands Dark Theme Installer for agy-ide"
echo "================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check specifically for the antigravity-ide command
ANTIGRAVITY_CLI=""
if command -v antigravity-ide &> /dev/null; then
    ANTIGRAVITY_CLI="antigravity-ide"
elif [ -f "/usr/local/bin/antigravity-ide" ]; then
    ANTIGRAVITY_CLI="/usr/local/bin/antigravity-ide"
elif [ -f "/Applications/Antigravity IDE.app/Contents/Resources/app/bin/antigravity-ide" ]; then
    ANTIGRAVITY_CLI="/Applications/Antigravity IDE.app/Contents/Resources/app/bin/antigravity-ide"
elif [ -f "/Applications/Antigravity.app/Contents/Resources/app/bin/antigravity-ide" ]; then
    ANTIGRAVITY_CLI="/Applications/Antigravity.app/Contents/Resources/app/bin/antigravity-ide"
else
    echo -e "${RED}❌ Error: antigravity-ide CLI not found!${NC}"
    echo "Please open Antigravity IDE, press Cmd+Shift+P, and run:"
    echo "  'Shell Command: Install antigravity-ide command in PATH'"
    exit 1
fi

echo -e "${GREEN}✓ antigravity-ide CLI found: $ANTIGRAVITY_CLI${NC}"

# Detect whether we are installing for Antigravity IDE or Antigravity
APP_DIR_NAME="Antigravity"
EXT_DIR_NAME=".antigravity"

if [[ "$ANTIGRAVITY_CLI" == *"Antigravity IDE"* ]]; then
    APP_DIR_NAME="Antigravity IDE"
    EXT_DIR_NAME=".antigravity-ide"
elif ps aux | grep -i "antigravity ide" | grep -v grep >/dev/null 2>&1; then
    APP_DIR_NAME="Antigravity IDE"
    EXT_DIR_NAME=".antigravity-ide"
elif [ -d "$HOME/Library/Application Support/Antigravity IDE" ] && [ ! -d "$HOME/Library/Application Support/Antigravity" ]; then
    APP_DIR_NAME="Antigravity IDE"
    EXT_DIR_NAME=".antigravity-ide"
fi

echo -e "${GREEN}✓ Target app detected: $APP_DIR_NAME${NC}"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ""
echo "📦 Step 1: Installing Islands Dark theme extension..."

EXT_DIR="$HOME/$EXT_DIR_NAME/extensions/bwya77.islands-dark-1.0.0"
rm -rf "$EXT_DIR"
mkdir -p "$EXT_DIR"
cp "$SCRIPT_DIR/package.json" "$EXT_DIR/"
cp -r "$SCRIPT_DIR/themes" "$EXT_DIR/"

if [ -d "$EXT_DIR/themes" ]; then
    echo -e "${GREEN}✓ Theme extension installed to $EXT_DIR${NC}"
else
    echo -e "${RED}❌ Failed to install theme extension${NC}"
    exit 1
fi

echo ""
echo "🔧 Step 2: Installing Custom UI Style extension..."
if "$ANTIGRAVITY_CLI" --install-extension subframe7536.custom-ui-style --force 2>/dev/null; then
    echo -e "${GREEN}✓ Custom UI Style extension installed${NC}"
else
    echo -e "${YELLOW}⚠️  Could not install Custom UI Style extension automatically${NC}"
    echo "   Please install 'Custom UI Style' manually from the agy-ide extensions sidebar."
fi

echo ""
echo "🔤 Step 3: Installing UI fonts (.otf & .ttf)..."

# Enable case-insensitive globbing locally to match .TTF or .OTF safely
shopt -s nullglob nocaseglob
FONT_FILES=("$SCRIPT_DIR/fonts/"*.otf "$SCRIPT_DIR/fonts/"*.ttf)
shopt -u nullglob nocaseglob

if [ ${#FONT_FILES[@]} -gt 0 ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        FONT_DIR="$HOME/Library/Fonts"
        echo "   Installing fonts to Mac Font Book: $FONT_DIR"
        for f in "${FONT_FILES[@]}"; do
            cp "$f" "$FONT_DIR/" 2>/dev/null || true
        done
        echo -e "${GREEN}✓ Fonts copied successfully${NC}"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
        echo "   Installing fonts to Linux User Space: $FONT_DIR"
        for f in "${FONT_FILES[@]}"; do
            cp "$f" "$FONT_DIR/" 2>/dev/null || true
        done
        fc-cache -f 2>/dev/null || true
        echo -e "${GREEN}✓ Fonts installed and font-cache refreshed${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No .otf or .ttf fonts found in fonts/ folder${NC}"
fi

echo ""
echo "⚙️  Step 4: Applying configuration settings..."

SETTINGS_DIR="$HOME/Library/Application Support/$APP_DIR_NAME/User"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SETTINGS_DIR="$HOME/.config/$APP_DIR_NAME/User"
fi

mkdir -p "$SETTINGS_DIR"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
    echo -e "${YELLOW}⚠️  Existing settings.json found${NC}"
    echo "   Backing up to settings.json.backup"
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"

    echo "   Merging settings safely using Node..."

    if command -v node &> /dev/null; then
        export SETTINGS_DIR
        SCRIPT_DIR_ESCAPED="${SCRIPT_DIR//\\/\\\\}"
        node << NODE_SCRIPT
const fs = require('fs');
const path = require('path');

function stripJsonc(text) {
    text = text.replace(/\/\/(?=(?:[^"\\\\]|\\\\.)*$)/gm, '');
    text = text.replace(/\/\*[\s\S]*?\*\//g, '');
    text = text.replace(/,\s*([}\]])/g, '\$1');
    return text;
}

const scriptDir = '${SCRIPT_DIR_ESCAPED}';
const newSettings = JSON.parse(stripJsonc(fs.readFileSync(path.join(scriptDir, 'settings.json'), 'utf8')));

const settingsDir = process.env.SETTINGS_DIR;
const settingsFile = path.join(settingsDir, 'settings.json');
const existingSettings = JSON.parse(stripJsonc(fs.readFileSync(settingsFile, 'utf8')));

const mergedSettings = { ...existingSettings, ...newSettings };

const stylesheetKey = 'custom-ui-style.stylesheet';
if (existingSettings[stylesheetKey] && newSettings[stylesheetKey]) {
    mergedSettings[stylesheetKey] = {
        ...existingSettings[stylesheetKey],
        ...newSettings[stylesheetKey]
    };
}

fs.writeFileSync(settingsFile, JSON.stringify(mergedSettings, null, 2));
console.log('Settings merged successfully');
NODE_SCRIPT
        echo -e "${GREEN}✓ Settings merged${NC}"
    else
        echo -e "${YELLOW}  Node.js missing. Please append theme parameters manually.${NC}"
    fi
else
    cp "$SCRIPT_DIR/settings.json" "$SETTINGS_FILE"
    echo -e "${GREEN}✓ Settings applied${NC}"
fi

echo ""
echo "🚀 Step 5: Refreshing your window..."
echo -e "${GREEN}✓ Setup complete!${NC}"
echo ""
echo "🎉 Islands Dark has been targeted to your agy-ide instance."
echo "   Reloading window..."
echo ""

"$ANTIGRAVITY_CLI" --reload-window 2>/dev/null || "$ANTIGRAVITY_CLI" . 2>/dev/null || true

echo -e "${GREEN}Done! 🏝️${NC}"