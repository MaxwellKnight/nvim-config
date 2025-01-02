-- [[ Basic Autocommands ]]
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('custom-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
