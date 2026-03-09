-- Toggle between Go implementation and test file
local function go_toggle_test_file()
  if vim.bo.filetype ~= 'go' then return end

  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == '' then return end

  local dir = vim.fn.fnamemodify(current_file, ':h')
  local base = vim.fn.fnamemodify(current_file, ':t')

  local target

  if base:match '_test%.go$' then
    -- If in test file → go to implementation file
    target = base:gsub('_test%.go$', '.go')
  else
    -- If in implementation → go to test file
    target = base:gsub('%.go$', '_test.go')
  end

  local full_path = dir .. '/' .. target

  -- Open file (creates buffer if not already open)
  vim.cmd('edit ' .. vim.fn.fnameescape(full_path))
end

-- Filetype-specific keymap for Go
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function(event)
    vim.keymap.set('n', 'gtt', go_toggle_test_file, {
      buffer = event.buf,
      desc = 'Toggle Go test file',
    })
  end,
})
