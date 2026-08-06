-- colorscheme
local tokyonight = require 'tokyonight'
tokyonight.setup {
  on_colors = function (colors)
    colors.fg_gutter = "#445880"
  end,
  on_highlights = function () end,
  transparent = true,
  styles = {
    sidebars = 'transparent',
    floats = 'transparent',
  },
}
tokyonight.load()

require 'multicursor-nvim' .setup {}
require 'tree-pairs' .setup {}

-- mini
require 'mini.ai' .setup()
require 'mini.surround' .setup()
require 'mini.clue' .setup()
require 'mini.files' .setup()
require 'mini.icons' .setup()
require 'mini.splitjoin' .setup()

---@diagnostic disable-next-line: missing-fields
require 'nvim-treesitter.config' .setup { }

require 'ufo' .setup {
    ---@diagnostic disable-next-line: unused-local
    provider_selector = function(_bufnr, _filetype, _buftype)
        return {'treesitter', 'indent'}
    end
}

require 'toggleterm' .setup {
  open_mapping = '<C-\'>',
  direction = 'float',
  start_in_insert = true,
  float_opts = {border = 'curved', title_pos = 'center'},
  hide_numbers = false,
}

require 'history' .setup {
  keybinds = {
    back = '<Backspace>',
    forward = '<S-Backspace>',
    view = '<C-Backspace>'
  }
}

require 'tiny-inline-diagnostic' .setup {
  options = {
    add_messages = { display_count = true, },
    multilines = { enabled = true, },
  },
}

require 'ccc' .setup {
  highlighter = {
    auto_enable = true,
    lsp = true,
  }
}

vim.diagnostic.config { virtual_text = false }

