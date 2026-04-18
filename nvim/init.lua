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
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- errors inline
vim.diagnostic.config {
	update_in_insert = true,
	severity_sort = true,
	virtual_text = true,
	jump = { float = true },
}

vim.cmd('syntax off')

---------------- PLUGIN SETUPS -----------------

vim.pack.add {
	-- dependencies --
	'https://github.com/nvim-lua/plenary.nvim',
	-- plugins --
	'https://github.com/lewis6991/gitsigns.nvim',
	'https://github.com/ellisonleao/gruvbox.nvim',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/windwp/nvim-autopairs',
	'https://github.com/christoomey/vim-tmux-navigator',
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/windwp/nvim-ts-autotag',
    'https://github.com/tpope/vim-surround',
	{ src = 'https://github.com/theprimeagen/harpoon', branch='harpoon2' },
	-- LSP --
	{ src = 'https://github.com/saghen/blink.cmp', branch = 'v1' },
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-lualine/lualine.nvim',
}

require("lualine").setup({
  options = {
    theme = "auto",
  },
  sections = {
    lualine_a = { "mode", "filename", "branch" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        "diagnostics",
      },
      {
        "diff",
        symbols = { added = "+", modified = "~", removed = "-" },
      }
    },
  },
})

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "leaderfa", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)

-- require("nvim-treesitter.install").update("all")
-- require("nvim-treesitter.config").setup({
--   ensure_installed = {
--     "javascript",
--     "typescript",
--   },
--   highlight = {
--     enable = true,
--   },
-- })


vim.cmd.colorscheme("gruvbox")

require('oil').setup({
  view_options = {
    show_hidden = true, 
  },
  skip_confirm_for_simple_edits = true,
})
require('nvim-autopairs').setup()

require('nvim-ts-autotag').setup()

require('blink.cmp').setup({
	fuzzy = { implementation = 'lua' },
	signature = { enabled = true },
	keymap = { preset = 'super-tab' },
})


-- Oil
vim.keymap.set('n', '<leader>o', '<cmd>Oil<cr>')

-- alternate buffer
vim.keymap.set('n', '<leader>a', '<C-^>')

-- Move selected block down
vim.keymap.set('v', 'J', ":<C-u>'<,'>m '>+1<CR>gv=gv")

-- Move selected block up
vim.keymap.set('v', 'K', ":<C-u>'<,'>m '<-2<CR>gv=gv")

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<leader><C-r>', '<cmd>restart<cr>')

-- remove search highlight
vim.keymap.set("n", "<C-x>", function() vim.cmd("nohlsearch") end)

-- boreder on K
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover({border = "rounded"})<cr>', opts)

-- zz remaps
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up' })
-- telescope -- 
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help tags' })

-- Telescope Workspace Errors
vim.keymap.set(
	'n',
	'<leader>se',
	function()
		builtin.diagnostics {
			severity = vim.diagnostic.severity.ERROR,
		}
	end,
	{ desc = '[S]how Workspace [E]rrors' }
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
	{ desc = '[S]earch Workspace [W]arnings' }
)

-- bg transparent
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })


local lsp_servers = {
	dockerls = {},
	html = {}, -- vscode-html-language-server
	cssls = {}, -- vscode-css-language-server
	jsonls = {}, -- vscode-json-language-server
	-- eslint = {}, -- vscode-eslint-language-server
	clangd = {},
	gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true, -- warns about unused function parameters
					nilness = true, -- warns about possible nil dereferences
					unusedwrite = true, -- warns about values written but never read
					shadow = true, -- variable shadowing
				},
				staticcheck = true, -- enables many linter-like warnings
			},
		},
	},
	ts_ls = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = 'all',
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = 'all',
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
				},
			},
		},
	},
	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = 'strict',
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = 'workspace',
					inlayHints = {
						variableTypes = true,
						functionReturnTypes = true,
						callArgumentNames = true,
					},
				},
			},
		},
	},
	jdtls = {},
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
	    vim.keymap.set("n", "grt", vim.lsp.buf.type_definition,
	    { buffer = bufnr, desc = "vim.lsp.buf.type_definition()", })
	    vim.keymap.set("n", "grf", vim.lsp.buf.format,
	    { buffer = bufnr, desc = "vim.lsp.buf.format()", })
	    vim.keymap.set("n", "grr", vim.lsp.buf.references,
	    { buffer = bufnr, desc = "vim.lsp.buf.references()", })
    end,
  })
  vim.lsp.enable(server)
end


-- toggle warnings
local warnings_enabled = true

vim.keymap.set('n', '<leader>tw', function()
  warnings_enabled = not warnings_enabled

  if warnings_enabled then
    vim.diagnostic.config {
      virtual_text = true,
      underline = true,
    }
    print("Warnings enabled")
  else
    vim.diagnostic.config {
      virtual_text = { severity = vim.diagnostic.severity.ERROR },
      underline = { severity = vim.diagnostic.severity.ERROR },
    }
    print("Warnings disabled")
  end
end, { noremap = true, silent = false })


vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

-- Open Oil when nvim is opened with a directory
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      require('oil').open(vim.fn.argv(0))
    end
  end,
})


-- require("statusline")
--
-- vim.opt.statusline = "%#StatuslineMode#%{luaeval('require(\"statusline\").mode()')}%* %f %#StatuslineBranch#%{luaeval('require(\"statusline\").branch()')}%*"
--
-- -- Optional: Add highlighting groups for colors
-- vim.cmd([[
--   highlight StatuslineMode ctermfg=black ctermbg=green
--   highlight StatuslineBranch ctermfg=white ctermbg=blue
-- ]])

-- :TSInstall bash c cpp diff html css javascript typescript tsx lua luadoc markdown vim python json go java yaml dockerfile sql regex query scss xml csv ini toml make helm graphql http rust php
