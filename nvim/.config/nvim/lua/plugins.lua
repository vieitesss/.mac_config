_ = vim.cmd [[packadd packer.nvim]]
_ = vim.cmd [[packadd vimball]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  ---- colorschemes
  use 'ellisonleao/gruvbox.nvim'

  ---- lsp
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use { 'tami5/lspsaga.nvim', config = function() require('lspsaga').setup() end }
  use 'onsails/lspkind.nvim'

  ---- cmp
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  ---- snippets
  use 'hrsh7th/vim-vsnip-integ'
  use 'rafamadriz/friendly-snippets'

  ---- programming utils
  use 'lervag/vimtex'
  use 'iamcco/markdown-preview.nvim'
  use 'CRAG666/code_runner.nvim'
  ----
  use 'szw/vim-maximizer'
  use 'christoomey/vim-tmux-navigator'
  use 'terrortylor/nvim-comment'
  use { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end }
  use 'windwp/nvim-ts-autotag'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'kyazdani42/nvim-tree.lua'
  -- telescope
  use { 'nvim-telescope/telescope.nvim', requires = {
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
  }
  }
  use 'nvim-telescope/telescope-media-files.nvim'
  use 'nvim-telescope/telescope-project.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'

  use 'voldikss/vim-floaterm'
  use { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }
end)
