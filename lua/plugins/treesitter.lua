return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"javascript",
				"typescript",
				"go",
				"c",
				"lua",
				"svelte",
				"markdown",
				"markdown_inline",
			},
			auto_install = false,
			highlight = {
				enable = true,
			},
		})
	end,
}
