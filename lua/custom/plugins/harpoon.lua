return {
  "ThePrimeagen/harpoon",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- Basic setup
    require("harpoon").setup({
      global_settings = {
        save_on_toggle = true,
        save_on_change = true,
      },
    })

    -- Harpoon keymaps
    local mark = require("harpoon.mark")
    local ui   = require("harpoon.ui")

    -- Add current file to Harpoon’s list
    vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = 'Harpoon: Add File' })
    -- Toggle Harpoon quick menu
    vim.keymap.set('n', '<leader>H', ui.toggle_quick_menu, { desc = 'Harpoon: Quick Menu' })

    -- Jump to marks 1–5
    for idx = 1, 5 do
      vim.keymap.set(
        'n',
        '<leader>' .. idx,
        function() ui.nav_file(idx) end,
        { desc = 'Harpoon: Go to file ' .. idx }
      )
    end
  end,
}
