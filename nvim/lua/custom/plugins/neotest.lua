-- return {
-- 	"nvim-neotest/neotest",
-- 	dependencies = {
-- 		"nvim-neotest/nvim-nio",
-- 		"nvim-lua/plenary.nvim",
-- 		"antoinemadec/FixCursorHold.nvim",
-- 		"nvim-treesitter/nvim-treesitter",
-- 		-- adapters language specific
-- 		"nvim-neotest/neotest-python", -- python
-- 		"nvim-neotest/neotest-golang", -- golang
-- 		"nvim-neotest/neotest-jest", -- jasvascript
-- 	},
-- 	config = function()
-- 		require("neotest").setup({
-- 			adapters = {
-- 				require("neotest-python")({
-- 					dap = { justMyCode = false },
-- 					runner = "pytest", -- or "unittest"
-- 				}),
-- 				require("neotest-go"),
-- 				require("neotest-jest")({
-- 					jestCommand = "npx jest",
-- 				}),
-- 			},
-- 		})
-- 	end,
-- }

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			-- {
			-- 	"nvim-treesitter/nvim-treesitter", -- Optional, but recommended
			-- 	branch = "main", -- NOTE; not the master branch!
			-- 	build = function()
			-- 		vim.cmd(":TSUpdate go")
			-- 	end,
			-- },
			{
				"fredrikaverpil/neotest-golang",
				version = "*",                               -- Optional, but recommended; track releases
				build = function()
					vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
				end,
			},
		},
		config = function()
			local config = {
				runner = "gotestsum", -- Optional, but recommended
			}
			require("neotest").setup({
				adapters = {
					require("neotest-golang")(config),
				},
			})
		end,
	},
}
