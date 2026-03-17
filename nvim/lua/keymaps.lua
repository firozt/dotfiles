-- ~/.config/nvim/lua/keymaps.lua
local M = {}

function M.setup()
  -- tmux panes
  vim.keymap.set('n', '<leader>tv', function() vim.fn.system 'tmux split-window -h' end, { desc = 'New [T]mux pane (horizontal split)' })
  vim.keymap.set('n', '<leader>th', function() vim.fn.system 'tmux split-window -v' end, { desc = 'New tmux pane (vertical split)' })

  -- line wrap for .md files
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true -- wrap at word boundaries not mid-word
    end,
  })

  -- Move selected block down
  vim.keymap.set('v', 'J', ":<C-u>'<,'>m '>+1<CR>gv=gv")

  -- Move selected block up
  vim.keymap.set('v', 'K', ":<C-u>'<,'>m '<-2<CR>gv=gv")

  -- Harpoon config
  local harpoon = require 'harpoon'
  harpoon:setup()
  vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end)
  vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

  vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end)
  vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end)
  vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end)
  vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end)

  -- Toggle previous & next buffers stored within Harpoon list
  vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end)
  vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end)

  -- Open neotest summary (toggle) and move cursor to it
  vim.keymap.set('n', '<leader>ts', function()
    local summary = require('neotest').summary
    summary.toggle()

    vim.cmd 'wincmd w'
  end, { desc = '[T]est [S]ummary' }) --   vim.cmd("Neotest summary")

  -- refactor name token
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]efactor Re[N]ame token' })

  -- Goto prev buff
  vim.keymap.set('n', '<leader>a', '<C-^>', { desc = 'Alternate previous buffer' })

  -- Next/Prev warnings
  vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN } end, { desc = '[N]ext [W]arning' })

  vim.keymap.set('n', ']e', function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN } end, { desc = '[N]ext [W]arning' })

  -- Next/Prev errors
  vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end, { desc = '[N]ext [E]rror' })
  vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end, { desc = '[P]rev [E]rror' })

  -- Split Window Vertically with oil open
  vim.keymap.set('n', '<leader>|', function()
    vim.cmd 'vsplit' -- open vertical split
    require('oil').open() -- open Oil in the new split
  end, { noremap = true, silent = true })

  -- zz remaps
  vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down' })
  vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up' })

  -- multiple ]f's (aerials.lua)
  vim.keymap.set('n', ']f', function()
    local count = vim.v.count1
    for _ = 1, count do
      vim.cmd 'AerialNext'
    end
  end, { buffer = bufnr, desc = 'Next function' })

  -- new tab
  vim.keymap.set('n', '<leader>n', '<cmd>tabnew<cr>', { desc = 'New Tab' })

  -- clears highlighted words when pressing esc (i.e from find)
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
  vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<CR>')

  -- diagnostics
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- navigate seemlessly between tmux and nvim panes
  local function tmux_or_nvim(direction)
    local current = vim.fn.winnr()
    vim.cmd('wincmd ' .. direction)

    -- If we didn't move, we're at the edge → go to tmux
    if current == vim.fn.winnr() then
      local tmux_dir = ({
        h = 'L',
        j = 'D',
        k = 'U',
        l = 'R',
      })[direction]

      vim.fn.system('tmux select-pane -' .. tmux_dir)
    end
  end

  vim.keymap.set('n', '<C-h>', function() tmux_or_nvim 'h' end)
  vim.keymap.set('n', '<C-j>', function() tmux_or_nvim 'j' end)
  vim.keymap.set('n', '<C-k>', function() tmux_or_nvim 'k' end)
  vim.keymap.set('n', '<C-l>', function() tmux_or_nvim 'l' end)

  -- Clear active snippet when leaving insert mode, fixes blink.cmp issue
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      local luasnip = require 'luasnip'
      if luasnip.in_snippet() then luasnip.unlink_current() end
    end,
  })

  -- surround highlighted text in quotes
  -- Double quotes
  vim.keymap.set('v', '<leader>"', 'c"<C-r>""<Esc>', { silent = true })

  -- Single quotes
  vim.keymap.set('v', "<leader>'", "c'<C-r>\"'<Esc>", { silent = true })

  -- Backticks
  vim.keymap.set('v', '<leader>`', 'c`<C-r>``<Esc>', { silent = true })

  -- telescope related keymaps
  local telescope = require 'telescope.builtin'

  -- Telescope Workspace Errors
  vim.keymap.set(
    'n',
    '<leader>se',
    function()
      telescope.diagnostics {
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
      telescope.diagnostics {
        severity = vim.diagnostic.severity.WARN,
      }
    end,
    { desc = '[S]earch Workspace [W]arnings' }
  )
end

return M
