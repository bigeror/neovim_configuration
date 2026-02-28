local packer_bootstrap = require 'bootstrap' ()

-- plugins
require 'packer' .startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'tpope/vim-sleuth'
  use 'nvim-tree/nvim-web-devicons'
  use 'theprimeagen/harpoon'
  use 'NStefan002/screenkey.nvim'
  use 'folke/tokyonight.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'nvim-mini/mini.nvim'
  use 'rachartier/tiny-inline-diagnostic.nvim'
  use 'mason-org/mason.nvim'
  use 'mason-org/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'

  use {'akinsho/toggleterm.nvim', tag = '*', config = function()
    require 'toggleterm' .setup {
      open_mapping = '<C-\'>',
      direction = 'float',
      start_in_insert = true,
      float_opts = {border = 'curved', title_pos = 'center'},
      hide_numbers = false,
    }
  end}

  if packer_bootstrap then require('packer').sync() else

  -- colorscheme
  local tokyonight = require 'tokyonight'
  tokyonight.setup {
    on_colors = function () end,
    on_highlights = function () end,
    transparent = true,
    styles = {
      sidebars = 'transparent',
      floats = 'transparent',
    },
  }
  tokyonight.load()

  require 'lualine_custom'
  require 'lsp'

  -- mini
  require 'mini.ai' .setup()
  require 'mini.surround' .setup()
  require 'mini.clue' .setup()
  require 'mini.files' .setup()
  require 'mini.indentscope' .setup {symbol = '│'}
  require 'mini.icons' .setup()
  require 'mini.splitjoin' .setup()
  require 'mini.pairs' .setup { mappings = {
    ['"'] = false,
    ["'"] = false,
    ['`'] = false,
  }}

  require('tiny-inline-diagnostic').setup {
    options = {
      add_messages = { display_count = true, },
      multilines = { enabled = true, },
    },
  }
  vim.diagnostic.config({ virtual_text = false })
end end)

-- settings
vim.g.mapleader = ' '
vim.cmd 'set nowrap'
vim.o.clipboard = 'unnamedplus'
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.termguicolors = true
vim.o.mouse = 'a'

-- keybinds
local telbuiltin = require 'telescope.builtin'
vim.keymap.set('n', '<leader><leader>', telbuiltin.find_files)
vim.keymap.set('n', '<leader>s', function() telbuiltin
  .grep_string({ search =  vim.fn.input('Grep > ') }) end)
vim.keymap.set('n', '<leader>q', function () MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)
vim.api.nvim_create_user_command('S', 'PackerSync', {})
vim.keymap.set('n', ';', function () vim.cmd('noh') end)

vim.keymap.set('n', '<C-;>', function () require 'screenkey' .toggle() return '<C-;>' end)

vim.keymap.set('n', '<leader>a', require 'harpoon.mark' .add_file)
vim.keymap.set('n', '<leader>e', require 'harpoon.ui' .toggle_quick_menu)

vim.keymap.set('n', '<leader><S-q>', function () require 'harpoon.ui' .nav_file(1) end)
vim.keymap.set('n', '<leader><S-w>', function () require 'harpoon.ui' .nav_file(2) end)
vim.keymap.set('n', '<leader><S-e>', function () require 'harpoon.ui' .nav_file(3) end)
vim.keymap.set('n', '<leader><S-u>', function () require 'harpoon.ui' .nav_file(4) end)
vim.keymap.set('n', '<leader><S-i>', function () require 'harpoon.ui' .nav_file(5) end)
vim.keymap.set('n', '<leader><S-o>', function () require 'harpoon.ui' .nav_file(6) end)

-- Always go forward with n, backward with N
vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

vim.cmd [[
nnoremap <silent> q: <Nop>
nnoremap <silent> q? <Nop>
nnoremap <silent> q/ <Nop>
]]




