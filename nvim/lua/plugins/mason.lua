return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-tool-installer").setup({
        auto_update = false,
        run_on_start = true,
        ensure_installed = {
          -- LSP
          "gopls",
          "ansible-language-server",
          "autotools-language-server",
          "bash-language-server",
          "dockerfile-language-server",
          "jq-lsp",
          "json-lsp",
          "typescript-language-server",
          "lua-language-server",
          "awk-language-server",
          "terraform-ls",

          -- DAP
          "delve",

          -- Linter
          "tflint",
          "tfsec",
          "systemdlint",
          "shellcheck",

          -- Formatter
          "golines",
          "gofumpt",
          "goimports",
          "goimports-reviser",
          "prettierd",
          "prettier",
        },
      })
    end,
  },
}
