return {
	{
		"michaelrommel/nvim-silicon",
		lazy = true,
		cmd = "Silicon",
		config = function()
			require("nvim-silicon").setup({
				font = "JetBrainsMono Nerd Font=34",
				theme = "Catppuccin Mocha",

				shadow_color = "#fff0",
				shadow_blur_radius = 0,
				shadow_offset_x = 0,
				shadow_offset_y = 0,

				background = "#fff0",
				pad_vert = 0,
				pad_horiz = 0,

				no_line_number = true,

				window_title = function()
					return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":.")
				end,

				output = function()
					local date = os.date("!%Y-%m-%dT%H-%M-%S")
					local path = "~/Pictures/Silicon/" .. date .. "_code.png"
					return path
				end,
			})
		end,
	},
}
