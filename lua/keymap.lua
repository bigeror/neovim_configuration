
local telbuiltin = require 'telescope.builtin'
vim.keymap.set('n', '<leader><leader>', telbuiltin.find_files)
vim.keymap.set('n', '<leader>s', function() telbuiltin
  .grep_string({ search =  vim.fn.input('Grep > ') }) end)
vim.keymap.set('n', '<leader>q', function () MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)

vim.keymap.set('n', ';', function () vim.cmd('noh') end)
vim.keymap.set('n', '<Esc>', function () vim.cmd('noh') end, {unique = false})

vim.keymap.set('n', '*', function()
  local word = vim.fn.expand('<cword>')
  vim.fn.setreg('/', '\\<' .. word)
  vim.opt.hlsearch = true
end)

vim.keymap.set('v', '*', function()
  local words = require 'thirdparty' .get_visual_selection_text()
  if words == nil then return end

  local word = table.concat(words, '\\n')
  print(word)
  vim.fn.setreg('/', word)
  vim.opt.hlsearch = true
  vim.cmd('visual')
end)

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.keymap.set('n', '<leader>c', ':CccPick<CR>')

vim.keymap.set('t', '<C-Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-X>', '<C-x>')
vim.keymap.set('n', '<C-x>', '<C-a>')
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'select everything' })

vim.keymap.set('n', '<leader>a', require 'harpoon.mark' .add_file)
vim.keymap.set('n', '<leader>e', require 'harpoon.ui' .toggle_quick_menu)

vim.keymap.set('n', '<leader>1', function () require 'harpoon.ui' .nav_file(1) end)
vim.keymap.set('n', '<leader>2', function () require 'harpoon.ui' .nav_file(2) end)
vim.keymap.set('n', '<leader>3', function () require 'harpoon.ui' .nav_file(3) end)
vim.keymap.set('n', '<leader>4', function () require 'harpoon.ui' .nav_file(4) end)
vim.keymap.set('n', '<leader>5', function () require 'harpoon.ui' .nav_file(5) end)
vim.keymap.set('n', '<leader>6', function () require 'harpoon.ui' .nav_file(6) end)

-- use what you prefer
vim.keymap.set('n', 'gw',  '<C-w>w')
vim.keymap.set('n', 'gq',  '<C-w>q')
vim.keymap.set('n', 'go',  '<C-w>o')
vim.keymap.set('n', 'gh',  '<C-w>h')
vim.keymap.set('n', 'gl',  '<C-w>l')
vim.keymap.set('n', 'gj',  '<C-w>j')
vim.keymap.set('n', 'gk',  '<C-w>k')
vim.keymap.set('n', 'gH',  '<C-w>H')
vim.keymap.set('n', 'gL',  '<C-w>L')
vim.keymap.set('n', 'gK',  '<C-w>K')
vim.keymap.set('n', 'gJ',  '<C-w>J')
vim.keymap.set('n', 'g|',  '<C-w>|')
vim.keymap.set('n', 'g\\', '<C-w>|')
vim.keymap.set('n', 'g_',  '<C-w>_')
vim.keymap.set('n', 'g-',  '<C-w>_')
vim.keymap.set('n', 'g=',  '<C-w>=')

-- Always go forward with n, backward with N
vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- substitution
vim.keymap.set('n', '<C-s>', function () vim.cmd("%s//"..vim.fn.input("Replace > ").."/gc") end)

vim.keymap.set({'n'}, ':', function ()
  vim.cmd('redir END')
  vim.cmd('redir => g:command_output')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":", true, false, true), "n", false)
end)

local open_output_split = function ()
  vim.cmd ([[
    redir END
    if exists('g:command_output')
    if empty(g:command_output)
      echoerr "no output"
    else
      vnew
      setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
      silent put=g:command_output
    endif
    endif
  ]])
end

vim.keymap.set('n', '<C-;>', function () open_output_split() end)


-- multicursors
local mc = require 'multicursor-nvim'
if mc then
  local set = vim.keymap.set
  set({"n", "x"}, "<C-k>", function() mc.lineAddCursor(-1) end)
  set({"n", "x"}, "<C-j>", function() mc.lineAddCursor(1) end)
  set({"n", "x"}, "<leader>n", function() mc.searchAddCursor(1) end)
  set({"n", "x"}, "<leader>s", function() mc.searchSkipCursor(1) end)
  set({"n", "x"}, "<leader>N", function() mc.searchAddCursor(-1) end)
  set({"n", "x"}, "<leader>S", function() mc.searchSkipCursor(-1) end)

  -- Add and remove cursors with control + left click.
  set("n", "<c-leftmouse>", mc.handleMouse)
  set("n", "<c-leftdrag>", mc.handleMouseDrag)
  set("n", "<c-leftrelease>", mc.handleMouseRelease)

  set("n", "<leader>a", mc.alignCursors)

  mc.addKeymapLayer(function(layerSet)
    -- Select a different cursor as the main one.
    layerSet({"n", "x"}, "<C-h>", mc.prevCursor)
    layerSet({"n", "x"}, "<C-l>", mc.nextCursor)

    -- Delete the main cursor.
    layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

    -- Enable and clear cursors using escape.
    layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
            mc.enableCursors()
        else
            mc.clearCursors()
        end
    end)
  end)

  -- Disable and enable cursors.
  vim.keymap.set({"n", "x"}, "<c-q>", mc.toggleCursor)

  local hl = vim.api.nvim_set_hl
  hl(0, "MultiCursorCursor", { reverse = true })
  hl(0, "MultiCursorVisual", { link = "Visual" })
  hl(0, "MultiCursorSign", { link = "SignColumn"})
  hl(0, "MultiCursorMatchPreview", { link = "Search" })
  hl(0, "MultiCursorDisabledCursor", { reverse = true })
  hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
  hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
end

vim.keymap.set('i', '<CR>', 'v:lua.cr_action()', { expr = true })

vim.keymap.set('i', '<Tab>',   [[pumvisible() ? '<C-n>' : '<Tab>']],   { expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? '<C-p>' : '<S-Tab>']], { expr = true })

vim.keymap.set('n', 'gr', vim.lsp.buf.rename)
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
vim.keymap.set('n', 'gR', require 'telescope.builtin'.lsp_references)
vim.keymap.set('n', 'K',  vim.lsp.buf.hover)

vim.keymap.set('n', 'gb', function() vim.cmd([[
  execute "vnew" | setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
]]) end)

vim.api.nvim_create_user_command("New", function() vim.cmd([[
  execute "vnew" | setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
]]) end, {})
