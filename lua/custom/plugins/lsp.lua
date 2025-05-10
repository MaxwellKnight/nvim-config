return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- ----------------------------------------------------------------------------
    -- 1) GLOBAL DIAGNOSTICS THROTTLING
    -- ----------------------------------------------------------------------------
    -- Only update diagnostics when you pause typing, and sort by severity.
    vim.diagnostic.config({
      virtual_text     = false,
      signs            = true,
      underline        = true,
      update_in_insert = false, -- <-- do not update while typing
      severity_sort    = true,
    })
    -- Also override the default handler for LSP diagnostics:
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        severity_sort    = true,
      }
    )

    -- ----------------------------------------------------------------------------
    -- 2) DEBOUNCE KEYPRESSES
    -- ----------------------------------------------------------------------------
    local common_flags = {
      debounce_text_changes = 150, -- wait 150ms after your last keystroke
    }

    -- ----------------------------------------------------------------------------
    -- 3) CAPABILITIES (cmp-nvim-lsp)
    -- ----------------------------------------------------------------------------
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- ----------------------------------------------------------------------------
    -- 4) PER-SERVER PERFORMANCE TUNES
    -- ----------------------------------------------------------------------------
    local servers = {
      clangd = {
        cmd = {
          'clangd',
          '--background-index',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
          '--function-arg-placeholders',
          '--fallback-style=llvm',
        },
        flags = common_flags,
        capabilities = capabilities,
        -- turn off semantic tokens if you don’t use them
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      },

      pyright = {
        flags = common_flags,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode       = 'off', -- disable strict checking
              autoSearchPaths        = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      },

      rust_analyzer = {
        flags = common_flags,
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            procMacro   = { enable = false }, -- faster startup
            cargo       = { loadOutDirsFromCheck = true },
            checkOnSave = {
              command = 'clippy',
              extraArgs = { '--no-deps' },                  -- skip dependencies
            },
            files       = { watcher = { enable = false } }, -- disable filewatcher
          },
        },
      },

      lua_ls = {
        flags = common_flags,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            telemetry = { enable = false }, -- no telemetry
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false, -- skip big scans
            },
          },
        },
      },
    }

    -- ----------------------------------------------------------------------------
    -- 5) SET UP MASON + LSPCONFIG
    -- ----------------------------------------------------------------------------
    require('mason').setup()
    require('mason-lspconfig').setup {
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name) -- default handler
          local opts = servers[server_name] or {}
          require('lspconfig')[server_name].setup(opts)
        end,
      },
    }

    -- ----------------------------------------------------------------------------
    -- 6) LIGHTWEIGHT LSP ATTACH (your existing mappings)
    -- ----------------------------------------------------------------------------
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
      callback = function(ev)
        local buf = ev.buf
        local function map(keys, fn, desc)
          vim.keymap.set('n', keys, fn, { buffer = buf, desc = 'LSP: ' .. desc })
        end

        map('gd', vim.lsp.buf.definition, 'Go to Definition')
        map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
        map('gi', vim.lsp.buf.implementation, 'Go to Implementation')
        map('gr', vim.lsp.buf.references, 'Go to References')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
      end,
    })
  end,
}
