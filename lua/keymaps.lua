local utils = require("utils")

utils.map("<Esc>", "<cmd>nohlsearch<CR>")
-- Keybinds to make split navigation easier.
-- --
-- create a new line in normal mode
utils.map("<CR>", "m`o<Esc>``", "Add new line under the cursor")
utils.map("<S-CR>", "m`O<Esc>``", "Add new line above the cursor")

-- Copy absolute path to pbcopy
vim.keymap.set("n", "<leader>cf", function()
	local path = vim.fn.expand("%:p")
	vim.fn.system("echo -n " .. vim.fn.shellescape(path) .. " | pbcopy")
	print("Copied: " .. path)
end, { desc = "Copy absolute path to clipboard" })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Auto read the contents file into the buffer when file is changed
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	pattern = "*",
	command = "checktime",
})
