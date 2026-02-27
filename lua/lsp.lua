-- lsp
local function LSP (use)
  use 'mason-org/mason.nvim'
  use 'mason-org/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'

  use 'folke/neodev.nvim'

  require 'neodev' .setup()

  require 'mason' .setup {ui = {keymaps = {
    install_package = "<Nop>" -- disable imperative installation through UI
  }}}

  local on_attach = function (_, bufnr)
    vim.keymap.set('n', 'gr', vim.lsp.buf.rename, {buffer = bufnr})
    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, {buffer = bufnr})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = bufnr})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer = bufnr})
    vim.keymap.set('n', 'gr', require 'telescope.builtin'.lsp_references, {buffer = bufnr})
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, {buffer = bufnr})
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  require 'mason-lspconfig' .setup { ensure_installed = {
    "rust_analyzer",
    "lua_ls",
  }, setup_handlers = {
    function (server_name)
      vim.lsp.config ( server_name,
        { on_attach = on_attach, capabilities = capabilities } )
    end,

    ['lua_ls'] = function ()
      local luasettings = {Lua = {
        workspace = {checkThirdParty = false},
        telemetry = {enable = false},
        completion = {callSnippet = "Replace"},
        -- diagnostics = {globals = {"vim"}},
      }}
      vim.lsp.config ( 'lua_ls',
        { on_attach = on_attach, settings = luasettings, capabilities = capabilities } )
    end,
  }}

  -- completions 
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rafamadriz/friendly-snippets'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/nvim-cmp'

  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  require 'luasnip.loaders/from_vscode' .lazy_load()
  luasnip.config.setup {}

  cmp.setup {
    snippet = { expand = function(args)
      luasnip.lsp_expand(args.body)
    end },
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete {},
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
        else fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
        else fallback()
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
  }

end

return {LSP = LSP}
