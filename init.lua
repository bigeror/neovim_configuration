local packer_bootstrap = require 'bootstrap' ()

-- plugins
require 'packer' .startup(function(use)
  use   'wbthomason/packer.nvim'
  use   'nvim-telescope/telescope.nvim'
  use   'nvim-lua/plenary.nvim'
  use   'tpope/vim-sleuth'
  use   'nvim-tree/nvim-web-devicons'
  use   'theprimeagen/harpoon'
  use   'nvim-treesitter/nvim-treesitter'
  use   'folke/tokyonight.nvim'
  use   'nvim-lualine/lualine.nvim'
  use   'nvim-mini/mini.nvim'
  use   'rachartier/tiny-inline-diagnostic.nvim'
  use   'mason-org/mason.nvim'
  use   'mason-org/mason-lspconfig.nvim'
  use   'neovim/nvim-lspconfig'
  use   'uga-rosa/ccc.nvim'
  use { 'wilfreddenton/history.nvim'    , requires = {{ 'nvim-lua/plenary.nvim' }} }
  use   'jake-stewart/multicursor.nvim'
  use   'yorickpeterse/nvim-tree-pairs'
  use { 'kevinhwang91/nvim-ufo'         , requires = 'kevinhwang91/promise-async'}
  use { 'akinsho/toggleterm.nvim'       , tag = '*'}

  if packer_bootstrap then require('packer').sync() else

  -- settings
  vim.g.mapleader = ' '
  vim.cmd 'set nowrap'
  vim.o.clipboard = 'unnamedplus'
  vim.o.number = true
  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
  vim.o.expandtab = true
  vim.o.relativenumber = true
  vim.o.signcolumn = 'yes'
  vim.o.termguicolors = true
  vim.o.mouse = 'a'
  vim.o.list = true

  vim.o.foldcolumn = '0'
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  require 'setup' -- setup most of the addons
  require 'lsp' -- setup lsps
  require 'lualine_custom' -- configure lualine to be fancy
  require 'godot' (false) -- shitty script to add godot compatibility, disabled by default
  require 'keymap' -- all the user defined keymaps
end end)

-- When first install the config you must run :S/:PackerSync and restart neovim
vim.api.nvim_create_user_command('S', 'PackerSync', {})

