file := justfile()

_default:
  just -l

# Install brew and Brew dependencies
deps:
  ./install deps

# Install Neovim
neovim version="latest":
  ./install neovim {{version}}

# Install keyboard configuration
kbd:
  ./install kbd

# Apply Mac defaults
defaults:
  ./install defaults

# Install dotfiles
dots:
  ./install dots

# Install others plus: apply defaults and load dotfiles
all:
  @just -f {{file}} deps defaults neovim dots kbd

# Update homebrew dependencies
update:
  ./update_packages

# Show homebrew dependencies
show_deps:
  cat ./installation/brew_dependencies.txt

theme t:
  ./change_theme {{t}}
