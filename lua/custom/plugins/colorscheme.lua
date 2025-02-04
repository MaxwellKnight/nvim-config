return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  init = function()
    require('catppuccin').setup {
      transparent_background = true,
    }

    vim.cmd.colorscheme 'catppuccin'
    vim.cmd.hi 'Comment gui=none'

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = 'none' })
      end,
    })
  end,
}
