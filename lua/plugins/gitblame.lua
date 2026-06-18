return {
	"f-person/git-blame.nvim",
	config = function()
		require("gitblame").setup({
			enabled = true, -- auto-show blame by default
			date_format = "%Y-%m-%d",
			message_template = "<author> • <date> • <summary>",
		})
	end,
	keys = {
		{ "<leader>gb", "<CMD>GitBlameToggle<CR>", desc = "Toggle git blame" },
	},
}
