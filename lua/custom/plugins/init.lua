return {
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Core plugins with configuration
  require 'custom.plugins.telescope',
  -- require 'custom.plugins.lsp',
  require 'custom.plugins.treesitter',
  require 'custom.plugins.completion',
  require 'custom.plugins.mini',
  require 'custom.plugins.colorscheme',
  require 'custom.plugins.conform',
  require 'custom.plugins.tmux',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
