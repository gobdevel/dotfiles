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
            require "custom.configs.null-ls"
          end,
      },
      config = function()
        require "plugins.configs.lspconfig"
        require "custom.configs.lspconfig"
      end,
  },

  { 
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
		"pyright"
      },
    },
  }

}

return plugins
