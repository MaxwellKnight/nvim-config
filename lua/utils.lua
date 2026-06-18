M = {}
function M.map(keycomb, action, description, mode)
	mode = mode or "n"
	vim.keymap.set(mode, keycomb, action, { desc = description })
end

function M.client_supports(client, method, bufnr)
	if not client then
		return false
	end

	if vim.fn.has("nvim-0.11") == 0 then
		return client:supports_method(method, bufnr)
	else
		return client.supports_method(method, { bufnr = bufnr })
	end
	return false
end

function M.is_in_deno()
	local lspconfig = require("lspconfig")
	local is_in_deno_repo = lspconfig.util.root_pattern("deno.json", "import_map.json", "deno.jsonc")(vim.fn.getcwd())
	local is_in_deno_part_of_repo = vim.fn.match(vim.fn.expand("%:p"), "supabase/functions") > -1
	return is_in_deno_repo or is_in_deno_part_of_repo
end

return M
