return {
  'stevearc/aerial.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    filter_kind = {
      'Function',
      'Method',
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', ']f', '<cmd>AerialNext<CR>', { buffer = bufnr })
      vim.keymap.set('n', '[f', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    end,
  },
}
