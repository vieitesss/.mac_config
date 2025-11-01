file := justfile()

_default:
  just -l

# Install package dependencies (brew on macOS, apt on Linux)
deps:
  ./install deps

# Install Neovim
neovim version="latest":
  ./install neovim {{version}}

# Install zinit and powerlevel10k
zinit:
  ./install zinit

# Install keyboard configuration (macOS only)
kbd:
  ./install kbd

# Apply Mac defaults (macOS only)
defaults:
  ./install defaults

# Install dotfiles
dots:
  ./install dots

# Install a tool from source (e.g., just source fzf)
source tool:
  ./install source {{tool}}

# Install everything
all:
  @just -f {{file}} deps defaults neovim zinit dots kbd

# Update package dependencies
update:
  ./update_packages

# Show package dependencies for current OS
show_deps:
  @if [ "$(uname)" = "Darwin" ]; then cat ./installation/brew_dependencies.txt; else cat ./installation/linux_dependencies.txt; fi

theme t:
  ./change_theme {{t}}
