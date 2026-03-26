return {
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup {
        -- Make Oil the default file explorer when opening a directory
        default_file_explorer = true,
        -- Send deleted files to trash (optional)
        delete_to_trash = true,
        -- Skip confirmation dialogs for simple edits (create/rename/delete)
        skip_confirm_for_simple_edits = true,
        -- View options
        view_options = {
          show_hidden = true,
          natural_order = true,
          -- Hide '..' and '.git' in the view
          is_always_hidden = function(name, _) return name == '..' or name == '.git' or name == '.DS_Store' end,
        },
        -- Window options
        win_options = {
          wrap = true,
        },
        -- Only show icon + filename
        columns = {},
      }

      -- Keymap to open Oil manually
      vim.keymap.set('n', '<leader>O', ':Oil .<CR>', { noremap = true, silent = true }, { desc = 'Open [O]il From Project Root' })
      vim.keymap.set('n', '<leader>o', function() require('oil').open(vim.fn.expand '%:p:h') end, { desc = 'Open [O]il in current file directory' })
    end,
  },
}
