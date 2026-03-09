-- ~/.config/nvim/lua/custom/plugins/flash.lua

return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    modes = {
      char = {
        enabled = true,
        -- highlight all matches when using f, F, t, T
        highlight = { backdrop = false },
        jump_labels = false,
      },
    },
  },
  keys = {
    { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
    { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
  },
}
