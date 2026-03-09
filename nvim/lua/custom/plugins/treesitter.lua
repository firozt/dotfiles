-- ~/.config/nvim/lua/custom/plugins/treesitter.lua
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    -- opts replaces the manual config function
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'diff',
        'html',
        'css',
        'javascript',
        'typescript',
        'tsx',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'python',
        'json',
        'go',
        'java',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      -- optional extras you might want
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
      playground = {
        enable = true, -- if you want Treesitter playground
        updatetime = 25,
        persist_queries = false,
      },
    },
  },
}
