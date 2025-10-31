# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform dotfiles repository (macOS and Linux) that manages system configuration using GNU Stow for symlink management. It provides automated installation of packages (Homebrew on macOS, apt on Linux), system defaults, custom keyboard layouts, Neovim, and configuration files for various tools (Alacritty, Aerospace, Hammerspoon, Karabiner, Zsh, Git).

**Platform Support:**
- **macOS**: Full support including window managers (Aerospace, Hammerspoon), keyboard customization (Karabiner), macOS defaults, and custom keyboard layouts
- **Linux**: Support for Debian/Ubuntu-based distributions using apt package manager. macOS-specific features are silently skipped.

## Essential Commands

### Installation & Setup

**Cross-platform commands** (automatically detect OS):
- **Install everything**: `just all` or `./install all` - Installs dependencies, Neovim, zinit/powerlevel10k, dotfiles, and macOS-specific features (kbd, defaults)
- **Install dependencies**: `just deps` or `./install deps` - Installs Homebrew packages (macOS) or apt packages (Linux)
- **Install Neovim**: `just neovim [version]` or `./install neovim [version]` (versions: `latest` or `nightly`)
- **Install zinit/powerlevel10k**: `just zinit` or `./install zinit` - Installs zinit plugin manager which auto-loads powerlevel10k on first zsh launch
- **Install dotfiles**: `just dots` or `./install dots` - Uses GNU Stow to symlink configs (macOS-specific configs skipped on Linux)
- **Update packages**: `just update` or `./update_packages` - Dumps current package list to appropriate file
- **Show dependencies**: `just show_deps` - Display package list for current OS

**macOS-specific commands**:
- **Apply macOS defaults**: `just defaults` or `./install defaults` - Skipped on Linux
- **Install keyboard layout**: `just kbd` or `./install kbd` - Skipped on Linux (requires restart on macOS)
- **Change theme**: `just theme <theme>` or `./change_theme <theme>` (available: `rose-pine`, `catppuccin`) - Updates Neovim, WezTerm, Sketchybar

**Package management**:
- macOS: Uses `installation/brew_dependencies.txt` (Brewfile format)
- Linux: Uses `installation/linux_dependencies.txt` (apt package list)

### Useful Aliases

The `core` function provides quick access to justfile recipes: `core <recipe>` runs `just -f ~/.mac_config/justfile <recipe>`

## Architecture

### Installation System

**Main installer**: `install` script
- **OS Detection**: Automatically detects macOS (Darwin) or Linux at startup using `uname`
- Modular installation functions for each component (dependencies, defaults, neovim, zinit, configs, kbd)
- Architecture detection (arm64/aarch64/x86_64) for platform-specific binary downloads
- Supports partial or full installation via command-line options
- Available commands: `deps`, `neovim`, `zinit`, `dots`, `defaults`, `kbd`, `all`

**Package Installation**:
- **macOS**: Uses Homebrew (`brew bundle install`)
  - Installs from `installation/brew_dependencies.txt`
  - Includes brew taps, formulae, casks, and go packages
- **Linux**: Uses apt package manager
  - Installs from `installation/linux_dependencies.txt`
  - Checks if each package is already installed before attempting installation
  - Warns on failed installations (some packages may need manual setup)

**Configuration loader**: Uses GNU Stow (`stow` command)
- Symlinks dotfile directories to `$HOME`
- **Cross-platform configs**: alacritty, zsh, git (loaded on all platforms)
- **macOS-only configs**: aerospace, hammerspoon, karabiner (skipped on Linux)
- Each directory follows XDG structure where applicable (e.g., `alacritty/.config/alacritty/`)

**Neovim installation**: Custom function in `install` script (cross-platform)
- Downloads pre-built binaries from GitHub releases for both macOS and Linux
- Detects OS and architecture to download correct binary (nvim-macos-arm64, nvim-linux-x86_64, etc.)
- Installs to `/usr/local/opt/nvim-<os>-<arch>`
- Creates symlink at `/usr/local/bin/nvim`
- Clones personal Neovim config from https://github.com/vieitesss/nvim to `~/.config/nvim`

### Theme System (macOS-focused)

**Theme switcher**: `change_theme` script
- Modifies configurations for Neovim (`~/.config/nvim/lua/vt/specs.lua`), WezTerm (`~/.config/wezterm/configs.lua`), and Sketchybar
- Sources color palettes from `palettes/<theme>` files
- Updates Sketchybar colors dynamically and reloads bar (macOS only)
- Current theme persisted in `palettes/current`
- Theme is loaded on shell startup via `.zshrc`
- **Note**: Currently macOS-focused due to Sketchybar dependency. On Linux, manually edit theme configs.

### Zsh Configuration

**Main config**: `zsh/.zshrc`
- Uses Zinit plugin manager
  - Installed via `just zinit` or `./install zinit`
  - Auto-installs to `~/.local/share/zinit/zinit.git` if not present
  - On first zsh launch, zinit automatically downloads and installs all plugins
- Key plugins: powerlevel10k (prompt), zsh-autosuggestions, zsh-completions, zsh-vi-mode, fzf-tab
- **Powerlevel10k**: Installed automatically via zinit on first zsh launch
  - Configure with `p10k configure`
  - Config stored in `~/.p10k.zsh`
- Vi mode with custom escape sequence (`nk`)
- Sources helper functions from `~/.zsh_functions` and `~/.profile`
- Dynamically sources all files in `aliases/` directory
- PATH management via `add-to-path` function for modular path configuration

**Aliases structure**: Organized by topic in `aliases/`
- `general.aliases.sh`: Core utilities (eza for ls, bat, navigation, editor shortcuts)
  - **Cross-platform compatibility**: `ls` alias adapts to OS (`ls -G` on macOS, `ls --color` on Linux)
  - **Cross-platform `copy()` function**: Uses `pbcopy` (macOS), `xclip`, or `xsel` (Linux) for clipboard operations
- `git.aliases.sh`: Git shortcuts
- `docker.aliases.sh`: Docker workflows
- `terraform.aliases.sh`: Terraform commands
- `aws.aliases.sh`: AWS CLI helpers
- `tmux.aliases.sh`: Tmux shortcuts
- `raspberry.aliases.sh`: Raspberry Pi connections
- `dagger.aliases.sh`: Dagger CLI installation helpers for different versions

### Window Management (macOS only)

**Aerospace**: Modern tiling window manager configuration in `aerospace/.config/aerospace/aerospace.toml`
- macOS-specific, not loaded on Linux

**Hammerspoon**: Lua-based automation in `hammerspoon/.hammerspoon/init.lua`
- macOS-specific, not loaded on Linux

**Yabai**: Window manager scripts in `yabai/scripts/` (wallpaper changes, notifications, resize)
- macOS-specific

**Linux alternatives**: For Linux window management, consider installing i3, sway, or other tiling window managers separately

### Terminal Emulators (cross-platform)

Multiple terminal emulator configs maintained:
- **Alacritty** (primary): YAML/TOML config in `alacritty/.config/alacritty/`
  - Cross-platform (macOS and Linux)
  - Fast, GPU-accelerated terminal
- **WezTerm, Kitty, Rio**: Alternative configs available, all support Linux

### Keyboard Customization (macOS only)

**Karabiner Elements**: Complex modifications in `karabiner/.config/karabiner/karabiner.json`
- macOS-specific, configuration not loaded on Linux

**Custom keyboard layout**: Binary layout files in `mac_keyboard_layout/`
- Copied to `/Library/Keyboard Layouts` during installation on macOS
- Not applicable on Linux (use system keyboard settings or xkb)

## Development Notes

- The repository uses `set -euo pipefail` for all bash scripts (strict error handling)
- Color output uses ANSI codes: GREEN for info, RED for errors, YELLOW for warnings
- **Package dependencies**:
  - macOS: `installation/brew_dependencies.txt` (Brewfile format with taps, brews, casks, go packages)
  - Linux: `installation/linux_dependencies.txt` (apt package list)
- **OS-specific behavior**: Scripts automatically detect OS via `uname` and adjust behavior
  - macOS-specific features (defaults, keyboard layouts, window managers) are silently skipped on Linux
  - No errors thrown when skipping platform-specific features
- macOS defaults applied via `installation/mac_defaults` script (macOS only)
- Neovim configuration is maintained separately at https://github.com/vieitesss/nvim

## Platform-Specific Features Summary

### Available on Both Platforms
- Core CLI tools (git, docker, kubernetes tools, cloud CLIs, etc.)
- Terminal emulators (WezTerm, Alacritty, Kitty)
- Neovim with custom configuration
- Zsh configuration with zinit plugins
- Tmux configuration
- Git configuration
- Cross-platform aliases and shell functions

### macOS Only
- Homebrew package management (casks, taps)
- Aerospace, Hammerspoon, Yabai (window managers)
- Karabiner Elements (keyboard customization)
- Custom keyboard layouts
- Sketchybar (status bar)
- macOS system defaults
- Theme switching script (depends on Sketchybar)

### Linux Only
- apt package management
- System keyboard/window manager configuration handled separately
