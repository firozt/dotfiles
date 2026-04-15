-- OPTIONS --


vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)


-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 500


vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }

vim.opt.wrap = false
vim.o.inccommand = 'split'
vim.o.scrolloff = 10
vim.o.confirm = true

-- remove bg
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })


-- yank
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

-- errors inline
vim.diagnostic.config {
  update_in_insert = true,
  severity_sort = true,
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = true,

  jump = { float = true },
}


vim.pack.add {
	{ src = 'https://github.com/ThePrimeagen/harpoon', branch= 'harpoon2' },
	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter'},
	-- LSP --
	{ src = 'https://github.com/saghen/blink.cmp', version = 'v1.*' },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
	{ src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
}

require('blink.cmp').setup({
  signature = { enabled = true },
  keymap = { preset = 'super-tab' },
})

require('mason').setup()

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
    },
  },
})

vim.lsp.enable({ 'lua_ls', 'gopls' })

require('oil').setup()

-- Open oil when nvim is opened with a directory
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      require('oil').open(vim.fn.argv(0))
    end
  end,
})

vim.keymap.set('n', '<leader>o', '<cmd>Oil<cr>')
vim.keymap.set('n', '<leader>a', '<C-^>')


-- local harpoon = require("harpoon")
require( 

-- vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
-- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
--
-- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
--
-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
