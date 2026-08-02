-- lsp
require 'mason' .setup()
require 'mini.completion' .setup { delay = { completion = 0, info = 0, signature = 0 } }

_G.cr_action = function()
  if vim.fn.complete_info()['selected'] ~= -1 then return '\25' end
  return '\r'
end

local capabilities = MiniCompletion.get_lsp_capabilities()

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

local nixd_settings = { diagnostic = {suppress = {'sema-wscaping-with'}}, capabilities = capabilities }
vim.lsp.config ( 'nixd', { settings = nixd_settings } )

local clangd_settings = { filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "h" }, capabilities = capabilities }
vim.lsp.config ( 'clangd', { settings = clangd_settings } )
vim.lsp.enable { 'nixd', 'clangd' }
