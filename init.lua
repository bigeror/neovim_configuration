local packer_bootstrap = require 'bootstrap' ()

-- plugins
require "packer" .startup(function(use)
  use "wbthomason/packer.nvim"
  use "nvim-telescope/telescope.nvim"
  use "nvim-lua/plenary.nvim"
  use "tpope/vim-sleuth"
  use 'nvim-tree/nvim-web-devicons'

  -- colorscheme
  use "folke/tokyonight.nvim"
  local tokyonight = require 'tokyonight'
  tokyonight.setup {
    on_colors = function () end,
    on_highlights = function () end,
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  }
  tokyonight.load()

  use 'nvim-lualine/lualine.nvim'
  require 'lualine_custom'

  require 'lsp' .LSP(use)

  -- mini
  use 'nvim-mini/mini.nvim'
  require 'mini.ai' .setup()
  require 'mini.surround' .setup()
  require 'mini.clue' .setup()
  require 'mini.files' .setup()
  require 'mini.indentscope' .setup {symbol = '│'}
  require 'mini.icons' .setup()
  require 'mini.pairs' .setup { mappings = {
    ['"'] = false,
    ["'"] = false,
    ['`'] = false,
  }}

  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require "toggleterm" .setup {
      open_mapping = '|',
      direction = 'float',
      start_in_insert = true,
      float_opts = {border = 'curved', title_pos = 'center'},
      hide_numbers = false,
    }
  end}

  -- automatically sync configuration on install
  if packer_bootstrap then require('packer').sync() end
end)

-- settings
vim.g.mapleader = ' '
vim.cmd "set nowrap"
vim.o.clipboard = 'unnamedplus'
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.termguicolors = true
vim.o.mouse = 'a'

-- keybinds
local telbuiltin = require 'telescope.builtin'
vim.keymap.set('n', '<leader><leader>', telbuiltin.find_files)
vim.keymap.set('n', '<leader>s', function() telbuiltin
  .grep_string({ search =  vim.fn.input("Grep > ") }) end)
vim.keymap.set('n', '<leader>q', function () MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)
vim.api.nvim_create_user_command('S', 'PackerSync', {})
