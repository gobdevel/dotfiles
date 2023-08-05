-- custom/configs/null-ls.lua

local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local sources = {
	formatting.prettier,
	formatting.stylua,
	formatting.black,
	formatting.clang_format.with({
		extra_args = { "--style", "Google" },
	}),
	formatting.beautysh.with({
    extra_args = { "-i", "2" },
  }),

	lint.shellcheck,
	lint.cpplint,

	code_actions.gitsigns,
}

null_ls.setup({
	-- debug = true,
	sources = sources,
})
