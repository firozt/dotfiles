-- Go LSP setup
local lspconfig = require 'lspconfig'
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.gopls.setup {
  capabilities = cmp_capabilities,
  on_attach = function(client, bufnr)
    local buf_map = function(mode, lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true }) end
    buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    buf_map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  end,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
}
