return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ensure_installed = {
          -- LSP
          "terraformls",
          "gopls",
          "ansiblels",
          "autotools_ls",
          "bashls",
          "dockerls",
          "jqls",
          "jsonls",
          "ts_ls",
          "lua_ls",

          -- DAP
          "delve",

          -- Linter
          "tflint",
          "tfsec",
          "systemdlint",
          "shellcheck",

          -- Formatter
        },
      })
    end,
  },
}
