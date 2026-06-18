local utils = require("utils")
return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gs = require("gitsigns")

		gs.setup({
			on_attach = function()
				utils.map("<leader>bg", function()
					gs.blame_line({ full = true })
				end)
			end,
		})
	end,
}
