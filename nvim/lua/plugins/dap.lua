return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapgo = require("dap-go")
      local dapui = require("dapui")

      dapgo.setup()
      dapui.setup()

      vim.keymap.set("n", "<F1>", dap.continue, {})
      vim.keymap.set("n", "<F2>", dap.step_over, {})
      vim.keymap.set("n", "<F3>", dap.step_into, {})
      vim.keymap.set("n", "<F4>", dap.step_out, {})
      vim.keymap.set("n", "<F5>", dap.step_back, {})
      vim.keymap.set("n", "<F13>", dap.restart, {})

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})

      vim.keymap.set("n", "<leader>dt", dapgo.debug_test, {})
      vim.keymap.set("n", "<leader>dl", dapgo.debug_last_test, {})

      vim.keymap.set("n", "<space>?", function()
        dapui.eval(nil, { enter = true })
      end)

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
