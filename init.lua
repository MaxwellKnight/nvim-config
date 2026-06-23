-- Disable LSP file-watching at the source, before any plugin or server loads.
-- On macOS vim._watch.watch opens one fd per directory and crashes with EMFILE
-- in large repos; disabling the capability isn't enough because some servers
-- register watchers regardless. Replacing _watchfunc with a no-op guarantees no
-- fs_event handle is ever created. See lua/plugins/lsp.lua for the full rationale
-- and how to re-enable watching via watchman's kqueue backend.
require("vim.lsp._watchfiles")._watchfunc = function()
	return function() end
end

require("opts")
require("keymaps")
require("config.lazy")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
