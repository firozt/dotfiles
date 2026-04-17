------------------- OPTIONS -------------------
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
vim.o.timeoutlen = 500
vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
vim.opt.wrap = false
vim.o.inccommand = 'split'
vim.o.scrolloff = 10
vim.o.confirm = true

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 100, })
    end,
})

-- errors inline
vim.diagnostic.config {
	update_in_insert = true,
	severity_sort = true,
	virtual_text = true,
	jump = { float = true },
}

vim.pack.add {
	-- dependencies --
	'https://github.com/nvim-lua/plenary.nvim',
	-- plugins --
	'https://github.com/lewis6991/gitsigns.nvim',
	'https://github.com/nvim-mini/mini.statusline',
	'https://github.com/ellisonleao/gruvbox.nvim',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/windwp/nvim-autopairs',
	'https://github.com/christoomey/vim-tmux-navigator',
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/windwp/nvim-ts-autotag',
	{ src = 'https://github.com/theprimeagen/harpoon', branch='harpoon2' },
	-- LSP --
	{ src = 'https://github.com/saghen/blink.cmp', branch = 'v1' },
	'https://github.com/nvim-treesitter/nvim-treesitter',
	-- 'https://github.com/mason-org/mason.nvim',
	'https://github.com/neovim/nvim-lspconfig'
}

-- colorscheme
vim.cmd.colorscheme("gruvbox")

require('mini.statusline').setup()
require('oil').setup()
require('nvim-autopairs').setup()
require('telescope').setup()
require('nvim-ts-autotag').setup()
require("nvim-treesitter.install").update("all")
require('nvim-treesitter.config').setup({
  ensure_installed = {
    "lua",
    "javascript",
    "typescript",
    "cpp",
    "c",
    "json",
    "html",
    "css",
    "bash",
    "go",
    "gomod",
    "gowork",
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})

require('blink.cmp').setup({
	fuzzy = { implementation = 'lua' },
	signature = { enabled = true },
	keymap = { preset = 'super-tab' },
})

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

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<leader><C-r>', '<cmd>restart<cr>')


-- telescope -- 
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help tags' })


-- bg transparent
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })


local lsp_servers = {
  lua_ls = {
    Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) }, },
  },
  clangd = {},
  rust_analyzer = {},
  pyright = {},
}

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig", -- default configs for lsps
  "https://github.com/mason-org/mason.nvim",                     -- package manager
  "https://github.com/mason-org/mason-lspconfig.nvim",           -- lspconfig bridge
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" -- auto installer
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = vim.tbl_keys(lsp_servers),
})

-- configure each lsp server on the table
-- to check what clients are attached to the current buffer, use
-- `:checkhealth vim.lsp`. to view default lsp keybindings, use `:h lsp-defaults`.
for server, config in pairs(lsp_servers) do
  vim.lsp.config(server, {
    settings = config,
    -- only create the keymaps if the server attaches successfully
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "grd", vim.lsp.buf.definition,
        { buffer = bufnr, desc = "vim.lsp.buf.definition()", })
      vim.keymap.set("n", "grf", vim.lsp.buf.format,
        { buffer = bufnr, desc = "vim.lsp.buf.format()", })
    end,
  })
end

local lspconfig = require('lspconfig')

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
    settings = {
	    gopls = {
		    semanticTokens = false,
	    },
    },
  },
}
