return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		dependencies = {
			"williamboman/mason.nvim",
		},
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		init = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 5000,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					["*"] = {
						"trim_whitespace",
						"trim_newlines",
					},
					lua = { "stylua" },
					javascript = {
						"prettier",
					},
					typescript = {
						"prettier",
					},
					markdown = {
						"mdformat",
						args = { "--wrap 80" },
					},
					go = {
						"goimports",
						"goimports-reviser",
						"gofumpt",
						"golines",
					},
					terraform = { "terraform_fmt" },
					sh = { "shellcheck" },
					zsh = { "shellcheck" },
				},
			})
		end,
	},
}
