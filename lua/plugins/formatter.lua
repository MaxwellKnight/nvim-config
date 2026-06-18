local utils = require("utils")

local formatters = {
	lua = { "stylua" },

	javascript = { "prettier", "eslint" },
	javascriptreact = { "prettier", "eslint" },
	typescript = { "prettier", "eslint" },
	typescriptreact = { "prettier", "eslint" },

	go = { "gofumpt" },
}

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = formatters,
		notify_on_error = true,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style.
			local disabled_fts = { c = false, cpp = false }

			return {
				timeout = 500,
				lsp_fallback = not disabled_fts[vim.bo[bufnr].filetype],
			}
		end,
	},
}
