local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	---- colorschemes
	use("ellisonleao/gruvbox.nvim")

	---- lsp
	use("neovim/nvim-lspconfig")
	use("williamboman/mason.nvim") -- Alternative to nvim-lsp-installer
	use("williamboman/mason-lspconfig.nvim")
	use({ "glepnir/lspsaga.nvim", branck = "main" })

	---- cmp
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")

	---- snippets
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")

	---- programming utils
	use("iamcco/markdown-preview.nvim")
	use("CRAG666/code_runner.nvim")
	----
	use("szw/vim-maximizer")
	use("christoomey/vim-tmux-navigator")
	use("terrortylor/nvim-comment")
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	})
	use("windwp/nvim-ts-autotag")
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("kyazdani42/nvim-tree.lua")
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	})

	-- formatting and linting
	use("jose-elias-alvarez/null-ls.nvim")
	use("jayp0521/mason-null-ls.nvim")

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-lua/popup.nvim",
		},
	})
	use("nvim-telescope/telescope-media-files.nvim")
	use("nvim-telescope/telescope-project.nvim")

	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
