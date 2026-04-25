----------------------------------------------------------------------------------------
---                                   OPTIONS                                         ---
-----------------------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 800
vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
vim.opt.wrap = false
vim.o.inccommand = 'split'
vim.o.scrolloff = 10
vim.o.confirm = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- persist undo
local undo_dir = vim.fn.stdpath 'data' .. '/undo'

if vim.fn.isdirectory(undo_dir) == 0 then vim.fn.mkdir(undo_dir, 'p') end

vim.opt.undodir = undo_dir
vim.opt.undofile = true

-- errors inline
vim.diagnostic.config {
  update_in_insert = true,
  severity_sort = true,
  virtual_text = true,

  float = {
    border = 'rounded',
    focusable = true,
    max_width = 80,
  },

  jump = {
    float = true,
  },
}

-- remove default syntax highlight, only use treestierr
vim.cmd 'syntax off'

-----------------------------------------------------------------------------------------
---                                 AUTO CMD'S                                        ---
-----------------------------------------------------------------------------------------

-- yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank { timeout = 100 } end,
})

-- attatch treesitter
vim.api.nvim_create_autocmd('FileType', {
  callback = function() pcall(vim.treesitter.start) end,
})

-----------------------------------------------------------------------------------------
---                               PLUGIN INSTALL                                      ---
-----------------------------------------------------------------------------------------

-- from base nvim
vim.cmd 'packadd nvim.difftool'
vim.cmd 'packadd nvim.undotree'

require('vim._core.ui2').enable {}

vim.pack.add {
  -- dependencies --
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/lewis6991/gitsigns.nvim',
  -- plugins --
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/tpope/vim-surround',
  'https://github.com/nvim-mini/mini.ai',
  { src = 'https://github.com/theprimeagen/harpoon', branch = 'harpoon2' },
  'https://github.com/stevearc/conform.nvim', -- formatting
  -- LSP + Auto-complete + Syntax --
  { src = 'https://github.com/saghen/blink.cmp', branch = 'v1' },
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
}

-----------------------------------------------------------------------------------------
---                                PLUGIN SETUP                                       ---
-----------------------------------------------------------------------------------------

-- theme
require('gruvbox').setup {
  transparent_mode = true,
}
-- vim.o.background = "light"
vim.cmd.colorscheme 'gruvbox'

-- formatters
require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff' },
    go = { 'goimports' },
    java = { 'google-java-format' },

    javascript = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },

    json = { 'prettierd' },
    html = { 'prettierd' },
    css = { 'prettierd' },
    scss = { 'prettierd' },
    markdown = { 'prettier' },
    yaml = { 'prettierd' },

    graphql = { 'prettierd' },
    vue = { 'prettierd' },
    angular = { 'prettierd' },
  },
}

require('mini.ai').setup()

require('lualine').setup {
  options = {
    theme = 'auto',
  },
  sections = {
    lualine_a = { 'mode', 'filename', 'branch' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        'diagnostics',
      },
      {
        'diff',
        symbols = { added = '+', modified = '~', removed = '-' },
      },
    },
  },
}

require('oil').setup {
  default_file_explorer = true,
  delete_to_trash = true,
  columns = { 'icon' },
  view_options = {
    show_hidden = true,
  },
  skip_confirm_for_simple_edits = true,
}

require('nvim-autopairs').setup()

require('nvim-ts-autotag').setup()

require('blink.cmp').setup {
  fuzzy = { implementation = 'lua' },
  signature = {
    enabled = true,
    window = {
      border = 'rounded',
    },
  },
  keymap = { preset = 'super-tab' },
}

require('telescope').setup {
  defaults = {
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.6,
        width = { padding = 0 },
        height = { padding = 0 },
      },
    },
  },
}

-----------------------------------------------------------------------------------------
---                                  KEYMAPS                                          ---
-----------------------------------------------------------------------------------------

-- quick fix next / prev with auto zz + toggle
vim.keymap.set('n', '<leader>q', function()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  if qf_winid > 0 then
    vim.cmd 'cclose'
  else
    vim.cmd 'copen'
  end
end, { noremap = true, desc = 'Toggle [q]uick fix list' })
vim.keymap.set('n', ']q', '<cmd>cnext<CR>zz', { noremap = true, desc = 'Next [q]uick fix list item' })
vim.keymap.set('n', '[q', '<cmd>cprev<CR>zz', { noremap = true, desc = 'Prev [q]uick fix list item' })

-- harpoon keymaps
local mark = require 'harpoon.mark'
local ui = require 'harpoon.ui'

vim.keymap.set('n', '<leader>fa', mark.add_file, { desc = 'Harpoon [a]dd' })
vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = 'Harpoon m[e]nu' })

vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end, { desc = 'Harpoon buffer [1]' })
vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end, { desc = 'Harpoon buffer [2]' })
vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end, { desc = 'Harpoon buffer [3]' })
vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end, { desc = 'Harpoon buffer [4]' })

-- vsplit
vim.keymap.set('n', '|', function()
  vim.cmd 'botright vsplit'
  require('oil').open()
end, { desc = 'Oil right split' })

-- new h split
vim.keymap.set('n', '-', function()
  vim.cmd 'botright split' -- bottom
  require('oil').open()
end, { desc = 'Oil bottom split' })

-- oil
vim.keymap.set('n', '<leader>o', '<cmd>Oil<cr>', { desc = '[O]il file browser (cwd)' })

-- oil root
vim.keymap.set('n', '<leader>O', function() require('oil').open(vim.fn.getcwd()) end, { desc = '[O]il file browser (root dir)' })

-- alternate buffer
vim.keymap.set('n', '<leader>a', '<C-^>', { desc = '[a]lternate buffer' })

-- Move selected block down
vim.keymap.set('v', 'J', ":<C-u>'<,'>m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })

-- Move selected block up
vim.keymap.set('v', 'K', ":<C-u>'<,'>m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

-- move between panes like tmux
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move pane left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move pane down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move pane up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move pane right' })

-- restart nvim
vim.keymap.set('n', '<leader><C-r>', '<cmd>restart<cr>', { desc = '[R]estart nvim' })

-- remove search highlight
vim.keymap.set('n', '<C-x>', '<cmd>nohlsearch<CR>', { desc = 'Remove highlighted search' })

-- zz remaps
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up' })

-- telescope --
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help tags' })

vim.keymap.set('n', '<leader>gd', builtin.git_commits, { noremap = true, desc = 'Git buffer commit histroy' })
vim.keymap.set('n', '<leader>gD', builtin.git_commits, { noremap = true, desc = 'Git commit history' })
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { noremap = true, desc = 'Git branches' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { noremap = true, desc = 'Git status' })

-- Telescope Workspace Errors
vim.keymap.set(
  'n',
  '<leader>se',
  function()
    builtin.diagnostics {
      severity = vim.diagnostic.severity.ERROR,
    }
  end,
  { desc = '[s]how Workspace [e]rrors' }
)

-- Workspace Warnings
vim.keymap.set(
  'n',
  '<leader>sw',
  function()
    builtin.diagnostics {
      severity = vim.diagnostic.severity.WARN,
    }
  end,
  { desc = '[s]earch Workspace [w]arnings' }
)

-- toggle warnings
local warnings_enabled = true

vim.keymap.set('n', '<leader>tw', function()
  warnings_enabled = not warnings_enabled

  if warnings_enabled then
    vim.diagnostic.config {
      virtual_text = true,
      underline = true,
    }
    print 'Warnings enabled'
  else
    vim.diagnostic.config {
      virtual_text = { severity = vim.diagnostic.severity.ERROR },
      underline = { severity = vim.diagnostic.severity.ERROR },
    }
    print 'Warnings disabled'
  end
end, { noremap = true, silent = false, desc = '[t]oggle [w]arnings' })

vim.keymap.set('n', '<leader>u', '<cmd>Undotree<cr>', {
  noremap = true,
  silent = true,
  desc = 'Toggle Undotree',
})

-- format keymap, display lines changed and filetype
vim.keymap.set('n', 'grf', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo.filetype
  local before = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  vim.notify('formatting buffer [' .. ft .. ']', vim.log.levels.INFO)
  require('conform').format { lsp_fallback = true, async = false }
  local after = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local changed = 0
  for i = 1, math.max(#before, #after) do
    if before[i] ~= after[i] then changed = changed + 1 end
  end
  vim.notify(string.format('formatted [%s] | changed lines: %d', ft, changed), vim.log.levels.INFO)
end, { desc = '[f]ormat file' })

-----------------------------------------------------------------------------------------
---                                  LSP SETUP                                        ---
-----------------------------------------------------------------------------------------

local lsp_servers = {
  lua_ls = {},
  dockerls = {},
  html = {},
  cssls = {},
  jsonls = {},
  clangd = {},
  jdtls = {},
  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          shadow = true,
          fieldalignment = true,
          nilness = true,
          unusedwrite = true,
          useany = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  ts_ls = {
    settings = {
      typescript = {
        preferences = {
          includeCompletionsForModuleExports = true,
          importModuleSpecifierPreference = 'non-relative',
        },
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'strict',
        },
      },
    },
  },
}

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup {
  ensure_installed = vim.tbl_keys(lsp_servers),
}

-- lsp server keymaps
for server, config in pairs(lsp_servers) do
  vim.lsp.config(server, {
    settings = config,
    on_attach = function(_, bufnr)
      vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'vim.lsp.buf.definition()' })
      vim.keymap.set('n', 'grt', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'vim.lsp.buf.type_definition()' })
      -- using formatter instead
      -- vim.keymap.set('n', 'grf', vim.lsp.buf.format, { buffer = bufnr, desc = 'vim.lsp.buf.format()' })
      vim.keymap.set('n', 'grr', vim.lsp.buf.references, { buffer = bufnr, desc = 'vim.lsp.buf.references()' })
      vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'vim.lsp.buf.implementation()' })
      vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'vim.lsp.buf.rename()' })
      vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'vim.lsp.buf.code_action()' })

      -- Diagnostics
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnr, desc = 'Go to previous diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = bufnr, desc = 'Go to next diagnostic' })
      -- Hover with custom border - ADD buffer = bufnr HERE
      vim.keymap.set(
        'n',
        'K',
        function()
          vim.lsp.buf.hover {
            border = 'rounded',
            focusable = true,
            max_width = 80,
            max_height = 30,
          }
        end,
        { buffer = bufnr, noremap = true, silent = true, desc = 'Hover' }
      )

      -- Signature help with rounded border
      vim.keymap.set(
        'n',
        '<C-k>',
        function()
          vim.lsp.buf.signature_help {
            border = 'rounded',
            focusable = true,
          }
        end,
        { buffer = bufnr, noremap = true, silent = true, desc = 'Signature help' }
      )

      -- Diagnostics with rounded border - ADD buffer = bufnr HERE
      vim.keymap.set(
        'n',
        '<leader>d',
        function()
          vim.diagnostic.open_float {
            border = 'rounded',
            focusable = true,
            max_width = 80,
          }
        end,
        { buffer = bufnr, noremap = true, silent = true, desc = 'Open diagnostic float' }
      )
    end,
  })
  vim.lsp.enable(server)
end

-- :TSInstall bash c cpp diff html css javascript typescript tsx lua luadoc markdown vim python json go java yaml dockerfile sql regex query scss xml csv ini toml make helm graphql http rust php
