-- ~/.config/nvim/ftplugin/java.lua
local jdtls = require('jdtls')
local mason = vim.fn.stdpath('data') .. '/mason'

local root_dir = vim.fs.root(0, { 'mvnw', 'pom.xml', 'gradlew', 'build.gradle', '.git' })
if not root_dir then return end

local project = vim.fn.fnamemodify(root_dir, ':t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project

jdtls.start_or_attach({
  cmd = {
    mason .. '/bin/jdtls',
    '--jvm-arg=-javaagent:' .. mason .. '/packages/jdtls/lombok.jar',
    '-data', workspace_dir,
  },
  root_dir = root_dir,
})
