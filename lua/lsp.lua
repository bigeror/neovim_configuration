-- lsp
local function LSP (use)
  use 'mason-org/mason.nvim'
  use 'mason-org/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'

  require 'mason' .setup()
  require 'mini.completion' .setup { delay = { completion = 0, info = 0, signature = 0 } }

  _G.cr_action = function()
    if vim.fn.complete_info()['selected'] ~= -1 then return '\25' end
    return '\r'
  end

  vim.keymap.set('i', '<CR>', 'v:lua.cr_action()', { expr = true })
  local imap_expr = function(lhs, rhs)
    vim.keymap.set('i', lhs, rhs, { expr = true })
  end

  imap_expr('<Tab>',   [[pumvisible() ? '\<C-n>' : '\<Tab>']])
  imap_expr('<S-Tab>', [[pumvisible() ? '\<C-p>' : '\<S-Tab>']])

  local capabilities = MiniCompletion.get_lsp_capabilities()

  vim.keymap.set('n', 'gr', vim.lsp.buf.rename)
  vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
  vim.keymap.set('n', 'gR', require 'telescope.builtin'.lsp_references)
  vim.keymap.set('n', 'K',  vim.lsp.buf.hover)

  require 'mason-lspconfig' .setup { ensure_installed = {
    'rust_analyzer',
    'lua_ls', -- defined in after plugin
  }, setup_handlers = {
    function (server_name)
      vim.lsp.config ( server_name, { capabilities = capabilities } )
    end,

    ['rust_analyzer'] = function ()
      local rustsettings = {['rust-analyzer'] = { cargo = {allFeatures = true} }}
      vim.lsp.config ( 'lua_ls', { settings = rustsettings, capabilities = capabilities })
    end,
  }}

  local on_attach = function(args) vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end
  vim.api.nvim_create_autocmd('LspAttach', { callback = on_attach })
end

return {LSP = LSP}
