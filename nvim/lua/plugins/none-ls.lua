return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local none_ls = require("null-ls")

      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local b = none_ls.builtins

      local sources = {
        -- Lua
        b.formatting.stylua,

        -- terraform
        b.formatting.terraform_fmt,

        -- go
        b.formatting.gofumpt,
        b.formatting.goimports,
        b.formatting.goimports_reviser,
        b.formatting.golines,

        -- typescript
        b.formatting.prettier,
      }

      none_ls.setup({
        debug = true,
        sources = sources,
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
              group = augroup,
              buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end
  }
}
