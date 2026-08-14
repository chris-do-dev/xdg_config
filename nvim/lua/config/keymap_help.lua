-- Popup reference for keybindings: <leader>k opens a floating window
-- listing both explicit keymaps (grouped by the plugin/config file that
-- sets them) and useful built-in Vim/Neovim bindings that never show up
-- in `:map` because they're core editor behavior, not registered mappings.
--
-- This list is maintained by hand (there's no reliable way to introspect
-- descriptions for Lua-function keymaps), so keep it in sync with the
-- files under lua/plugins/ and lua/config/remap.lua when those change.

local M = {}

local sections = {
	{
		title = "General",
		items = {
			{ "<leader>pv", "Open file explorer (netrw)" },
			{ "<leader>y", "Yank selection to system clipboard (visual)" },
			{ "<leader>u", "Toggle undo tree" },
		},
	},
	{
		title = "LSP",
		items = {
			{ "gd", "Go to definition" },
			{ "[d / ]d", "Previous / next diagnostic" },
			{ "<leader>ca", "Code action" },
			{ "<leader>rr", "List references" },
			{ "<leader>rn", "Rename symbol" },
			{ "<leader>gh", "Hover docs" },
			{ "(hold cursor)", "Show diagnostic under cursor" },
		},
	},
	{
		title = "Completion",
		items = {
			{ "<C-y> / <CR>", "Accept completion (insert mode)" },
		},
	},
	{
		title = "Formatting",
		items = {
			{ "<leader>f", "Format buffer (conform, falls back to LSP)" },
		},
	},
	{
		title = "Find / navigate (Telescope)",
		items = {
			{ "<leader>ff", "Find files" },
			{ "<leader>fg", "Live grep" },
			{ "<leader>fb", "Open buffers" },
			{ "<leader>fcb", "Fuzzy find in current buffer" },
			{ "<leader>fh", "Help tags" },
			{ "<leader>fo", "Recently opened files" },
			{ "<leader>fm", "Marks" },
			{ "<leader>fp", "Find file under ~/Code" },
			{ "<C-p>", "Git files" },
		},
	},
	{
		title = "Harpoon",
		items = {
			{ "<leader>aa", "Add file to Harpoon list" },
			{ "<C-e>", "Toggle Harpoon quick menu" },
		},
	},
	{
		title = "Git (fugitive)",
		items = {
			{ "<leader>gs", "Status" },
			{ "<leader>gb", "Blame" },
			{ "<leader>gd", "Diff split against index" },
			{ "<leader>gl", "Log to quickfix" },
		},
	},
	{
		title = "Testing (vim-test)",
		items = {
			{ "<leader>t", "Run nearest test" },
			{ "<leader>T", "Run file's tests" },
			{ "<leader>a", "Run test suite" },
			{ "<leader>l", "Re-run last test" },
			{ "<leader>g", "Jump to last-run test" },
		},
	},
	{
		title = "Debugging (DAP)",
		items = {
			{ "<F1>", "Continue" },
			{ "<F2>", "Step over" },
			{ "<F3>", "Step into" },
			{ "<F4>", "Step out" },
			{ "<F5>", "Step back" },
			{ "<F6>", "Toggle debug UI" },
			{ "<F12>", "Terminate" },
			{ "<F13>", "Restart" },
			{ "<leader>db", "Toggle breakpoint" },
			{ "<leader>dt", "Debug nearest Go test" },
			{ "<leader>dl", "Debug last Go test" },
			{ "<leader>?", "Evaluate expression under cursor" },
		},
	},
	{
		title = "Windows / panes",
		items = {
			{ "<C-h/j/k/l>", "Move between splits (crosses into tmux panes)" },
		},
	},
	{
		title = "Built-in essentials",
		items = {
			{ "h j k l", "Left / down / up / right" },
			{ "w b e", "Word forward / back / end" },
			{ "0 ^ $", "Line start / first non-blank / line end" },
			{ "gg G", "First / last line" },
			{ "{ }", "Previous / next paragraph" },
			{ "%", "Jump to matching pair" },
			{ "f/F/t/T{c}, ; ,", "Find char in line, repeat" },
			{ "d/c/y + motion", "Delete / change / yank over a motion" },
			{ 'diw daw di" da" dip dap dit dat', "Inner / around text objects" },
			{ "x r{c} R", "Delete char / replace char / replace mode" },
			{ ".", "Repeat last change" },
			{ "u <C-r>", "Undo / redo" },
			{ '"{r}y "{r}p', "Yank / paste to named register" },
			{ "qa ... q, @a, @@", "Record / play macro" },
			{ "m{a-z} `{a-z} '{a-z}", "Set mark / jump to mark" },
			{ "<C-o> <C-i>", "Back / forward in jumplist" },
			{ "/ ? n N", "Search forward / back, repeat" },
			{ "* #", "Search word under cursor forward / back" },
			{ ":sp :vsp <C-w>...", "Split windows / window commands" },
		},
	},
}

local function build_lines()
	local lines = { "# Keybindings", "" }
	for _, section in ipairs(sections) do
		local width = 0
		for _, item in ipairs(section.items) do
			width = math.max(width, vim.fn.strdisplaywidth(item[1]))
		end

		table.insert(lines, "## " .. section.title)
		table.insert(lines, "")
		for _, item in ipairs(section.items) do
			local pad = string.rep(" ", width - vim.fn.strdisplaywidth(item[1]))
			table.insert(lines, string.format("`%s`%s  %s", item[1], pad, item[2]))
		end
		table.insert(lines, "")
	end
	table.insert(lines, "_Press q or <Esc> to close_")
	return lines
end

function M.open()
	local lines = build_lines()

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "markdown"
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"

	local width = math.min(90, math.floor(vim.o.columns * 0.8))
	local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8))

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " Keybindings ",
		title_pos = "center",
	})

	vim.wo[win].wrap = false
	vim.wo[win].cursorline = true

	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	vim.keymap.set("n", "q", close, { buffer = buf, nowait = true, silent = true })
	vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true, silent = true })
end

vim.keymap.set("n", "<leader>k", M.open, { desc = "Show keybindings" })

return M
