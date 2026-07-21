return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig/util")

			require("lspconfig").intelephense.setup({})

			local auto_setup_servers = {
				"ansiblels",
				"bashls",
				"dockerls",
				"jqls",
				"jsonls",
				"ts_ls",
			}

			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				vim.keymap.set("n", "gq", function()
					vim.lsp.buf.format()
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

			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					virtual_text = false,
					signs = true,
					update_in_insert = false,
					underline = true,
				})

			-- Show diagnostics under the cursor when holding position
			vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold" }, {
				pattern = "*",
				command = "lua OpenDiagnosticIfNoFloat()",
				group = "lsp_diagnostics_hold",
			})

			for _, ls in ipairs(auto_setup_servers) do
				lspconfig[ls].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			lspconfig.autotools_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "config", "automake", "make" },
				root_dir = util.root_pattern("Makefile", "Makefile.*", "*.mk", "Makefile.am", "configure.ac"),
			})

			lspconfig.gopls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = util.root_pattern("go.work", "go.mod", ".git"),
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

			lspconfig.terraformls.setup({
				capabilities = capabilities,
				filetypes = { "tf", "hcl" },
				on_attach = function(client, _)
					client.server_capabilities.semanticTokensProvider = nil
				end,
			})

			lspconfig.lua_ls.setup({
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
		end,
	},
}
