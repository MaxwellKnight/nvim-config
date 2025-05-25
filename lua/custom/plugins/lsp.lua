-- ~/.config/nvim/lua/custom/plugins/lsp.lua
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'

      -- Common capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Define servers and their settings
      local servers = {
        clangd = {
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
            '--offset-encoding=utf-16',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              pattern = { '*.cpp', '*.hpp', '*.h' },
              callback = function()
                vim.lsp.buf.format { async = false }
              end,
            })
            vim.bo[bufnr].tabstop = 2
            vim.bo[bufnr].softtabstop = 2
            vim.bo[bufnr].shiftwidth = 2
            vim.bo[bufnr].expandtab = true
          end,
        },
        pyright = {},
        rust_analyzer = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- Install and configure Mason and LSP servers
      require('mason').setup()
      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(servers),
      }
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local opts = servers[server_name] or {}
            opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, opts.capabilities or {})
            lspconfig[server_name].setup(opts)
          end,
        },
      }
    end,
  },
}
