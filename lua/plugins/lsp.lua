return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	init = function()
		local utils = require("utils")
		local servers = require("servers")
		local lsp_proto_methods = vim.lsp.protocol.Methods
		local mason_installer = require("mason-tool-installer")
		local mason = require("mason-lspconfig")
		local lspconfig = require("lspconfig")
		-- TODO: make sure to get default capabilities
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Disable LSP dynamic file-watching registration. On macOS the default
		-- libuv watcher opens one fd per directory; servers like rust-analyzer and
		-- clangd register huge recursive globs (target/, build/) and exhaust the
		-- open-file limit, crashing vim/_watch.lua with EMFILE. Servers keep doing
		-- their own internal file watching, so functionality is unaffected.
		capabilities.workspace = capabilities.workspace or {}
		capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = false }

		local ensure_installed = vim.tbl_keys(servers or {})

		vim.list_extend(ensure_installed, {
			"stylua",
		})

		-- installed all servers
		mason_installer.setup({ ensure_installed = ensure_installed })

		-- initiate mason, adds default capabilities to server
		mason.setup({
			ensure_installed = {},
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}

					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

					lspconfig[server_name].setup(server)
				end,
			},
		})

		local builtin = require("telescope.builtin")

		local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
		local lsp_detach_augroup = vim.api.nvim_create_augroup("lsp-detach", { clear = true })
		local lsp_attach_augroup = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

		vim.api.nvim_create_autocmd("LSPAttach", {
			group = lsp_attach_augroup,
			callback = function(event)
				-- mappings
				utils.map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
				utils.map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
				utils.map("gr", builtin.lsp_references, "[G]oto [R]eferences")
				utils.map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
				utils.map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
				utils.map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
				utils.map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				utils.map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				utils.map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- enabling word highlight on hover
				if utils.client_supports(client, lsp_proto_methods.textDocument_documentHighlight, event.buf) then
					-- enabling highlight on hover
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					-- clearing once cursor moves
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					-- clearing once lsp detaches
					vim.api.nvim_create_autocmd("LspDetach", {
						group = lsp_detach_augroup,
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
						end,
					})
				end
			end,
		})

		-- setting up diagnostics
		vim.diagnostic.config({
			severity_sort = true,
			underline = { severity = vim.diagnostic.severity.ERROR },
			float = { border = "rounded", source = "if_many" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			},
			virtual_text = {
				current_line = true,
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		utils.map("<leader>e", vim.diagnostic.open_float, "Show diagnostic [E]rror messages")
		utils.map("<leader>q", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")
	end,
}
