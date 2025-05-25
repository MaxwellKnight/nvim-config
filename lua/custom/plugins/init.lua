return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim',           config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'j-hui/fidget.nvim',
      'folke/neodev.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local util     = require('lspconfig.util')

      -- your servers table, root_dir overrides, etc.
      local servers = {
        clangd = { … },
        pyright = {},
        rust_analyzer = {},
        eslint = {
          root_dir = util.root_pattern(
            '.eslintrc.js', '.eslintrc.json', 'package.json'
          ),
          cmd       = { 'vscode-eslint-language-server', '--stdio' },
          filetypes = { 'javascript', 'typescript', 'vue', 'svelte' },
        },
        omnisharp = { … },
        lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
      }

      -- setup mason & mason-lspconfig
      require('mason').setup()
      require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local opts = vim.tbl_deep_extend('force', { capabilities = vim.lsp.protocol.make_client_capabilities() }, servers[server_name] or {})
            lspconfig[server_name].setup(opts)
          end,
        },
      }
    end,
  },
}
