-- ~/.config/nvim/lua/custom/plugins/ts-autotag.lua
return {
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'tsx' },
    event = 'InsertEnter',
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        -- Remove the per_filetype override that was disabling HTML
      }
    end,
  },
}
