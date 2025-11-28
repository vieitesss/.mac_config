# My mac configuration

## Prerequisites

- Mac or Linux (tested in Debian-based OS)
- [Just](https://github.com/casey/just) (optional)

## Installation

The main script to install everything is the `install` script.

It is used in the `justfile`. So, you can run `just` and check the options available, or just run the `install` script directory, providing the preferred options.

```bash
just
# or
./install
```

## What's installed

- [Neovim](https://github.com/neovim/neovim) -> latest version by default
    - Includes my [Neovim configuration](https://github.com/vieitesss/nvim)
- Dependencies -> all the packages that I have installed (Mac or Linux)
- Defaults -> the default configuration (Mac only)
- [zinit](https://github.com/zdharma-continuum/zinit) -> ZSH plugin manager
- configurations -> the defaults loaded are:
    - alacritty, tmux, zsh, git
    - aerospace, hammerspoon, karabiner (Mac only)
- keyboard layout -> The keyboard layout configuration, custom Colemak (Mac only)

## Notes

- The configuration files are managed using [stow](https://www.gnu.org/software/stow/manual/html_node/Introduction.html).

From the root of this repository:

```bash
# Example
#   ~/.mac_config/zsh/.zshrc
#   ~/.mac_config/zsh/.zsh/
#          ^
#      From here

stow zsh 

# Creates the symlinks:
# ~/.zshrc -> ~/.mac_config/zsh/.zshrc
# ~/.zsh/ -> ~/.mac_config/zsh/.zsh/
```
