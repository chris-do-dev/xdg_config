return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local util = require("lspconfig.util")

			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, opts)
				vim.keymap.set("n", "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, opts)
				vim.keymap.set("n", "<leader>rr", function()
					vim.lsp.buf.references()
				end, opts)
				vim.keymap.set("n", "<leader>rn", function()
					vim.lsp.buf.rename()
				end, opts)
				vim.keymap.set("n", "<leader>gh", function()
					vim.lsp.buf.hover()
				end, opts)
			end

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Shared defaults for every server. Per-server overrides below
			-- only need to specify what's actually different from this.
			vim.lsp.config("*", {
				on_attach = on_attach,
				capabilities = capabilities,
			})

			function OpenDiagnosticIfNoFloat()
				for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
					if vim.api.nvim_win_get_config(winid).zindex then
						return
					end
				end
				-- THIS IS FOR BUILTIN LSP
				vim.diagnostic.open_float(0, {
					scope = "cursor",
					focusable = false,
					close_events = {
						"CursorMoved",
						"CursorMovedI",
						"BufHidden",
						"InsertCharPre",
						"WinLeave",
					},
				})
			end

			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
			})

			-- Show diagnostics under the cursor when holding position
			vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold" }, {
				pattern = "*",
				command = "lua OpenDiagnosticIfNoFloat()",
				group = "lsp_diagnostics_hold",
			})

			vim.lsp.config("autotools_ls", {
				filetypes = { "config", "automake", "make" },
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					on_dir(util.root_pattern("Makefile", "Makefile.*", "*.mk", "Makefile.am", "configure.ac")(fname))
				end,
			})

			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
							staticcheck = true,
							gofumpt = true,
						},
					},
				},
			})

			vim.lsp.config("terraformls", {
				filetypes = { "tf", "hcl" },
				on_attach = function(client, _)
					client.server_capabilities.semanticTokensProvider = nil
				end,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						format = {
							enable = true,
						},
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								"vim",
								"require",
							},
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.enable({
				"intelephense",
				"ansiblels",
				"bashls",
				"dockerls",
				"jqls",
				"jsonls",
				"ts_ls",
				"autotools_ls",
				"gopls",
				"terraformls",
				"lua_ls",
			})
		end,
	},
}
