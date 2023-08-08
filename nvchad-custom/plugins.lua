local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				-- defaults
				"vim",
				"lua",

				-- web dev
				"python",
				"cpp",
				"json",
				-- "vue", "svelte",

				-- low level
				"c",
			},
		},
	},
	-- In order to modify the `lspconfig` configuration:
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("custom.configs.null-ls")
			end,
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},

	{
		"joechrisellis/lsp-format-modifications.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"clangd",
				"python-lsp-server",
				"shellcheck",
				"yapf",
				"stylua",
				"clang-format",
				"beautysh",
				"cpplint",
			},
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			git = {
				enable = true,
			},

			filters = {
				dotfiles = true,
			},

			renderer = {
				highlight_git = true,
				icons = {
					show = {
						git = true,
					},
				},
			},
		},
	},
}

return plugins
