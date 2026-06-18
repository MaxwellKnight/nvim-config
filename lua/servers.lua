local nvim_lsp = require("lspconfig")

S = {}

S.clangd = {
	cmd = {
		"clangd",
		"--fallback-style=webkit",
	},
}

S.rust_analyzer = {
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				buildScripts = { enable = true },
			},
			procMacro = { enable = true },
			checkOnSave = true,
			check = {
				command = "clippy",
			},
			completion = {
				callable = { snippets = "fill_arguments" },
			},
		},
	},
}

S.lua_ls = {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}

return S
