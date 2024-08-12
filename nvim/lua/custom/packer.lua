-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	})

	use("alexghergh/nvim-tmux-navigation")
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("ThePrimeagen/harpoon")
	use("mbbill/undotree")
	use("tpope/vim-fugitive")
	use("junegunn/fzf")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- Debugging
	use({
		"mfussenegger/nvim-dap",
		requires = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
	})

	-- Testing
	use({
		"vim-test/vim-test",
		requires = {
			{ "preservim/vimux" },
		},
	})

	-- LSP
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})

	use({
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use("nvimtools/none-ls.nvim")

	-- UI
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	use({
		"michaelrommel/nvim-silicon",
		cmd = "Silicon",
		config = function()
			require("nvim-silicon").setup({
				font = "JetBrainsMono Nerd Font=34;Noto Emoji=34",
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
	})
end)
