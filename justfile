file := justfile()

_default:
  just -l

# Brew and Brew dependencies
deps:
  -./install deps

neovim:
  -./install neovim

# Keyboard configuration
kbd:
  -./install kbd

# Mac defaults
defaults:
  -./install defaults

# Dotfiles
dots:
  -./install dots

# Others plus: apply defaults and load dotfiles
all:
  @just -f {{file}} deps defaults neovim dots kbd
