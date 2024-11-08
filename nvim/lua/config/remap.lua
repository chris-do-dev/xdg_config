vim.g.mapleader = " "

-- Normal mode keymaps
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Visual mode keymaps
vim.keymap.set("v", "<leader>y", '"*y')

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
