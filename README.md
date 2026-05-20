<div align="center">

# 🏝️ Islands Dark for Antigravity & agy-ide

**A port of [Islands Dark](https://github.com/bwya77/vscode-dark-islands) to Google Antigravity IDE**

Deep backgrounds · Warm syntax highlighting · Glass-morphism UI · Smooth animations

![preview](https://raw.githubusercontent.com/bwya77/vscode-dark-islands/main/assets/CleanShot%202026-02-14%20at%2021.47.05%402x.png)

![preview2](https://raw.githubusercontent.com/bwya77/vscode-dark-islands/main/assets/CleanShot%202026-02-14%20at%2021.45.00%402x.png)

</div>

---

## What is this?

Antigravity is Google's AI-first IDE built on the VS Code engine (often invoked via the `antigravity` or `antigravity-ide` CLI). While it's compatible with VS Code themes, it uses **different file paths** for extensions and settings depending on whether you are using the classic Antigravity release or the new **Antigravity IDE** (`agy-ide`).

This repo ports the beautiful Islands Dark theme + UI customizations to both flavors of Antigravity with a fully automated installer.

---

## Features

- 🎨 **Islands Dark color theme** — deep `#131217` base with warm syntax highlighting across JS, TS, Python, Go, Rust, HTML, CSS, JSON, YAML and more
- 🪟 **Glass-morphism panels** — sidebar, editor, terminal and auxiliary bar with rounded corners, subtle borders and directional lighting
- 💊 **Pill-shaped activity bar** — floating, centered icons with an embossed active state
- 🌊 **Smooth animations** — breadcrumbs fade on hover, tab actions fade in, scrollbars transition on hover
- ✨ **File icon glow** — color-matched `drop-shadow` on file icons in the sidebar and tabs
- 🔔 **Rounded notifications** — toast and notification center with glass borders and deep shadows
- 🚀 **Dynamic Environment Detection** — supports both classic `Antigravity` and the new `Antigravity IDE` (`agy-ide`)
- 🔤 **Pre-bundled Font Installer** — includes and automatically installs both `.otf` and `.ttf` formats of the design system's fonts

---

## Installation

### One-liner

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/tsxr1ck/antigravity-ide-dark-islands/main/install.sh)
```

### Manual

```bash
git clone https://github.com/tsxr1ck/antigravity-ide-dark-islands
cd antigravity-ide-dark-islands
bash install.sh
```

After installation, **restart Antigravity**.

> **"Corrupt installation" warning?** That's expected when CSS injection is active. Click the gear icon → **Don't Show Again**.

---

## Uninstallation

If you want to remove the theme and revert all changes:

```bash
bash uninstall.sh
```

This will:
- Remove the Islands Dark theme extension
- Optionally uninstall Custom UI Style extension
- Restore your settings from the backup (if available)
- Reload the window

> **Note:** Fonts are not automatically removed, as they might be used by other applications. You can manually delete them from your system Fonts directory if desired.

---

## Fonts

The theme looks best with these three fonts:

| Font | Used for | Reference / Source |
|------|----------|--------------------|
| **IBM Plex Mono** | Editor | [ibm.com/plex](https://www.ibm.com/plex/) |
| **FiraCode Nerd Font Mono** | Terminal | [nerdfonts.com](https://www.nerdfonts.com/) |
| **Bear Sans UI** | UI panels & tabs | [bwya77/vscode-dark-islands](https://github.com/bwya77/vscode-dark-islands) |

These fonts (both `.otf` and `.ttf` formats) are **pre-bundled** directly in the `fonts/` folder of this repository. When you run `install.sh`, the installer will automatically copy and install them to your system Font Book (macOS) or user font directory (Linux). No manual downloads are required!

---

## How it works

The installer performs these steps:

1. **Detects the IDE target**: Automatically checks for the `antigravity-ide` CLI versus the classic `antigravity` CLI to determine directory structures.
2. **Copies the theme extension** to the appropriate extensions directory (e.g., `~/.antigravity-ide/extensions/` or `~/.antigravity/extensions/`).
3. **Installs [Custom UI Style](https://github.com/subframe7536/vscode-custom-ui-style)** via the detected CLI (enables CSS injection).
4. **Installs fonts** (.otf & .ttf) to `~/Library/Fonts` (macOS) or `~/.local/share/fonts` (Linux).
5. **Merges settings** safely into your IDE `settings.json` — your existing settings are backed up first, and Node.js is used to merge stylesheet configurations non-destructively.
6. **Reloads the window** to apply changes.

### Path Comparison

VS Code, Antigravity, and the new Antigravity IDE store resources in separate directories:

| Resource | VS Code | Antigravity | Antigravity IDE (`agy-ide`) |
|---|---|---|---|
| **Extensions** | `~/.vscode/extensions/` | `~/.antigravity/extensions/` | `~/.antigravity-ide/extensions/` |
| **Settings (macOS)** | `~/Library/Application Support/Code/User/` | `~/Library/Application Support/Antigravity/User/` | `~/Library/Application Support/Antigravity IDE/User/` |
| **Settings (Linux)** | `~/.config/Code/User/` | `~/.config/Antigravity/User/` | `~/.config/Antigravity IDE/User/` |
| **CLI Command** | `code` | `antigravity` | `antigravity-ide` |

---

## Credits

- Original theme and concept: [bwya77/vscode-dark-islands](https://github.com/bwya77/vscode-dark-islands)
- CSS injection engine: [subframe7536/custom-ui-style](https://github.com/subframe7536/vscode-custom-ui-style)

---

## License

MIT
