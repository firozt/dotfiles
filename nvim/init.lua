-- loads options
require 'options'

-- allow % for xml/html tags
vim.cmd 'runtime macros/matchit.vim'

-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    if vim.hl then
      vim.hl.on_yank()
    else
      vim.highlight.on_yank()
    end
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  -- themes + small plugins

  { 'NMAC427/guess-indent.nvim', opts = {} },
  -- {
  --   'neanias/everforest-nvim',
  --   version = false,
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('everforest').setup {
  --       background = 'medium',
  --       ui_contrast = 'high',
  --     }
  --     vim.cmd.colorscheme 'everforest'
  --   end,
  -- },

  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        contrast = 'hard',
        invert_background = false,
        transparent = true,
        overrides = {
          Normal = { bg = 'NONE' },
          SignColumn = { bg = 'NONE' },
          LineNr = { bg = 'NONE' },
          CursorLineNr = { bg = 'NONE' },
          VertSplit = { bg = 'NONE' },
        },
      }
      vim.cmd 'colorscheme gruvbox'
    end,
  },

  -- load custom dir plugins, most themes are in lua/custom/plugins/*.lua
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- load keymaps after telescope , as we use it
require('keymaps').setup()

-- load autocmds
require 'autocmds'

-- make bg transparent
-- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

-- fixed js treesitter syntax tree stuff TODO - fix
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function() pcall(vim.treesitter.start) end,
})

-- suppresses md warnings+errors
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown' },
  callback = function() vim.diagnostic.enable(false, { bufnr = 0 }) end,
})
