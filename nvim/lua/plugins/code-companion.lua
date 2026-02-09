return {
  "olimorris/codecompanion.nvim",
  opts = {
    strategies = {
      chat = {
        adapter = "copilot",
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" },
      opts = {
        html = { enabled = false },
        latex = { enabled = false },
      },
      config = function(_, opts)
        require("render-markdown").setup(opts)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "markdown",
          callback = function(ev)
            vim.treesitter.start(ev.buf, "markdown")
          end,
        })
      end,
    },
  },
}
