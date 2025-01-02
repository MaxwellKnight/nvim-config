return {
  'folke/tokyonight.nvim',
  priority = 1000,
  init = function()
    -- Load the colorscheme
    vim.cmd.colorscheme 'catppuccin'
    -- Configure highlights
    vim.cmd.hi 'Comment gui=none'
  end,
}
