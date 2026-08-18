return {
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local diffview = require("diffview")

			diffview.setup({
				enhanced_diff_hl = true,
				view = {
					default = {
						layout = "diff2_horizontal",
					},
					merge_tool = {
						layout = "diff3_mixed",
						disable_diagnostics = true,
					},
				},
			})

			-- Open/close diffview for working tree
			vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen<cr>", { desc = "Open diffview" })
			vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" })
			-- File history for current file or whole repo
			vim.keymap.set(
				"n",
				"<leader>dh",
				"<cmd>DiffviewFileHistory %<cr>",
				{ desc = "File history (current file)" }
			)
			vim.keymap.set("n", "<leader>dH", "<cmd>DiffviewFileHistory<cr>", { desc = "File history (repo)" })
		end,
	},
}
