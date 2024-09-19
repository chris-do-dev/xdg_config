return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      --		extensions = {
      --			fzf = {
      --				fizzy = true,
      --				override_generic_sorter = true,
      --				override_file_sorter = true,
      --				case_mode = "smart_case",
      --			},
      --		},
    })
    --telescope.load_extension("fzf")

    vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    vim.keymap.set("n", "<leader>fcb", builtin.current_buffer_fuzzy_find, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
  end,
}
