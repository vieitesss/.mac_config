_default:
  just -l

# Install all
install:
  ./install

# Install neovim
neovim:
  ./install neovim
