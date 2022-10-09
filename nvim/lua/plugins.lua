-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Icons package required by many plugins
	use 'kyazdani42/nvim-web-devicons'

	-- File Explorer
	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}

	-- Status line
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	-- Buffer display as tab
	use {
		'romgrk/barbar.nvim',
		requires = {'kyazdani42/nvim-web-devicons'}
	}

	-- Theme / Colorscheme
	use "savq/melange"
	use 'jacoborus/tender.vim'
	use 'ellisonleao/gruvbox.nvim'

	-- Generate Autopairs
	use "windwp/nvim-autopairs"
	-- Scope viewer
	use 'lukas-reineke/indent-blankline.nvim'
	-- quick commenter
	use 'preservim/nerdcommenter'
    -- Editor Config
    use 'gpanders/editorconfig.nvim'

	-- Start a terminal session
	use {"akinsho/toggleterm.nvim", tag = '*' }

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
	
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		requires = {'nvim-lua/plenary.nvim'}
	}

	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	use 'L3MON4D3/LuaSnip' -- Snippets plugin

end)
