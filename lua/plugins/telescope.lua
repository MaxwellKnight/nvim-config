local utils = require("utils")

return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "echasnovski/mini.icons", opts = {} },
	},
	config = function()
		require("telescope").setup({
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = { "--hidden" },
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")

		utils.map("<leader>pf", builtin.find_files, "[P]roject [F]iles")
		utils.map("<leader>sg", builtin.live_grep, "[S]earch by [G]rep")
		utils.map("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
	end,
}
