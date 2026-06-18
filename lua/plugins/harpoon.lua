local utils = require("utils")
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		local harpoon_keys = { "t", "g", "s", "a" }

		utils.map("<leader>a", function()
			harpoon:list():add()
		end, "[A]dd item to harpoon's list")

		utils.map("<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, "Open harpoon's quick menu")

		for i, v in ipairs(harpoon_keys) do
			local keycomb = string.format("<leader>f%s", v)

			utils.map(keycomb, function()
				harpoon:list():select(i)
			end, string.format("Go to item numeber %d", i))
		end
	end,
}
