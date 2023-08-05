local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local servers = { "clangd" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- Without the loop, you would have to manually set up each LSP
--
lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pylint = {
          enabled = true,
        },
        pyflakes = {
          enabled = false,
        },
        autopep8 = {
          enabled = false,
        },
        pycodestyle = {
          maxLineLength = 85,
        },
      }
    },
  },
}
--
-- lspconfig.cssls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }
