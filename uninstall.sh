#!/bin/bash

set -e

echo "🗑️  Islands Dark Theme Uninstaller for Antigravity"
echo "===================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if antigravity-ide command is available
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
    echo -e "${YELLOW}⚠️  Warning: antigravity-ide CLI not found${NC}"
    echo "   Some features may not work properly"
fi

if [ -n "$ANTIGRAVITY_CLI" ]; then
    echo -e "${GREEN}✓ antigravity-ide CLI found: $ANTIGRAVITY_CLI${NC}"
fi

# Detect whether we are uninstalling for Antigravity IDE or Antigravity
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

echo ""
echo "📦 Step 1: Removing Islands Dark theme extension..."

EXT_DIR="$HOME/$EXT_DIR_NAME/extensions/bwya77.islands-dark-1.0.0"
if [ -d "$EXT_DIR" ]; then
    rm -rf "$EXT_DIR"
    echo -e "${GREEN}✓ Theme extension removed from $EXT_DIR${NC}"
else
    echo -e "${YELLOW}⚠️  Theme extension not found (already removed or never installed)${NC}"
fi

echo ""
echo "🔧 Step 2: Custom UI Style extension..."
echo -e "${BLUE}ℹ️  Do you want to uninstall the Custom UI Style extension?${NC}"
echo "   (This extension might be used by other themes or customizations)"
if [ -t 0 ]; then
    read -p "   Uninstall Custom UI Style? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -n "$ANTIGRAVITY_CLI" ]; then
            if "$ANTIGRAVITY_CLI" --uninstall-extension subframe7536.custom-ui-style 2>/dev/null; then
                echo -e "${GREEN}✓ Custom UI Style extension uninstalled${NC}"
            else
                echo -e "${YELLOW}⚠️  Could not uninstall Custom UI Style extension${NC}"
                echo "   You can uninstall it manually from the Extensions panel"
            fi
        else
            echo -e "${YELLOW}⚠️  Cannot uninstall without Antigravity CLI${NC}"
            echo "   Please uninstall manually from the Extensions panel"
        fi
    else
        echo -e "${BLUE}ℹ️  Keeping Custom UI Style extension${NC}"
    fi
else
    echo -e "${BLUE}ℹ️  Non-interactive mode: Keeping Custom UI Style extension${NC}"
fi

echo ""
echo "⚙️  Step 3: Restoring Antigravity settings..."

SETTINGS_DIR="$HOME/Library/Application Support/$APP_DIR_NAME/User"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SETTINGS_DIR="$HOME/.config/$APP_DIR_NAME/User"
fi

SETTINGS_FILE="$SETTINGS_DIR/settings.json"
BACKUP_FILE="$SETTINGS_FILE.backup"

if [ -f "$BACKUP_FILE" ]; then
    echo -e "${BLUE}ℹ️  Found settings backup from installation${NC}"
    if [ -t 0 ]; then
        read -p "   Restore settings from backup? (Y/n): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            cp "$BACKUP_FILE" "$SETTINGS_FILE"
            echo -e "${GREEN}✓ Settings restored from backup${NC}"
            echo "   Backup file kept at: $BACKUP_FILE"
        else
            echo -e "${BLUE}ℹ️  Settings not restored${NC}"
            echo "   You can manually restore from: $BACKUP_FILE"
        fi
    else
        # Non-interactive mode: restore by default
        cp "$BACKUP_FILE" "$SETTINGS_FILE"
        echo -e "${GREEN}✓ Settings restored from backup${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No settings backup found${NC}"
    echo ""
    echo -e "${BLUE}ℹ️  To manually remove Islands Dark settings, you need to:${NC}"
    echo "   1. Open Antigravity settings (Cmd+,)"
    echo "   2. Change 'Color Theme' to another theme"
    echo "   3. Remove 'custom-ui-style.stylesheet' setting"
    echo "   4. Remove 'custom-ui-style.font.monospace' setting"
    echo "   5. Optionally change editor and terminal fonts back to defaults"
fi

echo ""
echo "🔤 Step 4: Fonts..."
echo -e "${BLUE}ℹ️  Fonts were installed to your system font directory${NC}"
echo "   We recommend keeping them as they might be used by other applications"
echo ""
if [ -t 0 ]; then
    read -p "   Do you want to see the font locations? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "   macOS fonts location: $HOME/Library/Fonts"
            echo "   Look for: Bear Sans UI, IBM Plex Mono, FiraCode Nerd Font"
        else
            echo "   Linux fonts location: $HOME/.local/share/fonts"
            echo "   Look for: Bear Sans UI, IBM Plex Mono, FiraCode Nerd Font"
        fi
        echo ""
        echo "   You can remove them manually if desired"
    fi
fi

echo ""
echo "🚀 Step 5: Cleaning up..."

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FIRST_RUN_FILE="$SCRIPT_DIR/.islands_dark_first_run"
if [ -f "$FIRST_RUN_FILE" ]; then
    rm "$FIRST_RUN_FILE"
    echo -e "${GREEN}✓ Removed first run marker${NC}"
fi

echo ""
echo -e "${GREEN}✓ Uninstallation complete!${NC}"
echo ""

if [ -n "$ANTIGRAVITY_CLI" ]; then
    echo "   Reloading Antigravity to apply changes..."
    "$ANTIGRAVITY_CLI" --reload-window 2>/dev/null || "$ANTIGRAVITY_CLI" . 2>/dev/null || true

    if [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e 'display notification "Islands Dark theme uninstalled successfully!" with title "🗑️ Islands Dark Uninstaller"' 2>/dev/null || true
    fi
else
    echo -e "${YELLOW}⚠️  Please manually reload Antigravity to see the changes${NC}"
    echo "   You can do this by:"
    echo "   • Pressing Cmd+Shift+P (macOS) or Ctrl+Shift+P (Linux)"
    echo "   • Type 'Developer: Reload Window'"
    echo "   • Or simply restart Antigravity"
fi

echo ""
echo -e "${GREEN}Done! 🗑️${NC}"
echo ""
echo -e "${BLUE}Note: If you change your mind, you can reinstall by running:${NC}"
echo "   bash install.sh"
echo ""
