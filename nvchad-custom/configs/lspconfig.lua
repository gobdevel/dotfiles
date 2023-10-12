local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
capabilities.offsetEncoding = { "utf-16" }

local lspconfig = require("lspconfig")
local servers = { "clangd" }


-- local on_attach_call = function(client, bufnr)
--   on_attach(client, bufnr)
--   -- config for Range formatter lsp-format-modifications.nvim
--   client.server_capabilities.documentFormattingProvider = true
--   client.server_capabilities.documentRangeFormattingProvider = true
--   local augroup_id = vim.api.nvim_create_augroup(
--     "FormatModificationsDocumentFormattingGroup",
--     { clear = false }
--   )
--   vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = bufnr })
--
--   vim.api.nvim_create_autocmd(
--     { "BufWritePre" },
--     {
--       group = augroup_id,
--       buffer = bufnr,
--       callback = function()
--         local lsp_format_modifications = require"lsp-format-modifications"
--         lsp_format_modifications.format_modifications(client, bufnr)
--       end,
--     }
--   )
-- end

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- Without the loop, you would have to manually set up each LSP

lspconfig.pylsp.setup {
  root_dir = lspconfig.util.root_pattern('aos', 'leblon'),
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
        -- pycodestyle = {
        --   maxLineLength = 85,
        -- },
      }
    },
  },
}

-- lspconfig.cssls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }
