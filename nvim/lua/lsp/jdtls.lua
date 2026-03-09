-- lua/lsp/jdtls.lua
-- Automatically starts JDTLS for Java files with workspace, autocomplete, and inlay hints

local has_jdtls, jdtls = pcall(require, 'jdtls')
if not has_jdtls then
  vim.notify('nvim-jdtls not found! Install it via Lazy.nvim', vim.log.levels.WARN)
  return
end

-- FileType autocmd for Java
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    local lspconfig = require 'lspconfig'

    -- Determine project root (Git, Maven, or Gradle)
    local root_dir = lspconfig.util.root_pattern('.git', 'mvnw', 'gradlew')(vim.fn.getcwd())
    if not root_dir then
      vim.notify('Could not find project root for JDTLS', vim.log.levels.WARN)
      return
    end

    -- Workspace folder for this project
    local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
    vim.fn.mkdir(workspace_dir, 'p') -- create folder if missing

    -- Mason-installed JDTLS path
    local jdtls_cmd = vim.fn.stdpath 'data' .. '/mason/bin/jdtls'

    -- Attach autocomplete capabilities from blink.cmp
    local capabilities = {}
    local has_cmp, cmp_lsp = pcall(require, 'blink.cmp')
    if has_cmp then capabilities = cmp_lsp.get_lsp_capabilities() end

    -- Start or attach JDTLS
    jdtls.start_or_attach {
      cmd = { jdtls_cmd },
      root_dir = root_dir,
      workspace_dir = workspace_dir,
      capabilities = capabilities,
      settings = {
        java = {
          eclipse = { downloadSources = true },
          configuration = { updateBuildConfiguration = 'interactive' },
          maven = { downloadSources = true },
          referencesCodeLens = { enabled = true },
          implementationsCodeLens = { enabled = true },
          format = { enabled = true },
        },
      },
      init_options = {
        bundles = {},
      },
    }

    -- Optional: Inlay hints toggle
    vim.keymap.set('n', '<leader>th', function()
      if vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.disable()
      else
        vim.lsp.inlay_hint.enable()
      end
    end, { desc = '[T]oggle Java [H]ints', buffer = 0 })
  end,
})
