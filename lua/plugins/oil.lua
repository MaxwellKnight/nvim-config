local utils = require("utils")

return {
	"stevearc/oil.nvim",
	opts = {
		columns = {
			"icon",
			-- "permissions",
			"size",
			-- "mtime",
		},
		view_options = {
			show_hidden = true,
		},
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,

	init = function()
		utils.map("-", "<CMD>Oil<CR>", "open parent directory")
	end,
}
