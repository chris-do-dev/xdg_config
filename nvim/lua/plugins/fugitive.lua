return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
			vim.keymap.set("n", "<leader>gb", function()
				vim.cmd.Git("blame")
			end)
			vim.keymap.set("n", "<leader>gd", vim.cmd.Gdiffsplit)
			vim.keymap.set("n", "<leader>gl", vim.cmd.Gclog)
		end,
	},
}
