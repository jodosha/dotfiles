return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<Leader>bn"] = { ":bnext<cr>", desc = "Next buffer" },
          ["<Leader>bp"] = { ":bprev<cr>", desc = "Previous buffer" },
          ["<Leader>bcp"] = {
            function() vim.fn.setreg("+", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")) end,
            desc = "Copy relative path",
          },
          ["<Leader>rs"] = { ":TermExec cmd='bundle exec rspec %' direction='float'<cr>", desc = "RSpec file" },
          ["<Leader>rsl"] = {
            function()
              local line_num = vim.fn.line "."
              vim.cmd("TermExec cmd='bundle exec rspec %:" .. line_num .. "' direction='float'")
            end,
            desc = "RSpec line",
          },
          ["<C-a>"] = { "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions" },
          ["<LocalLeader>a"] = { "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Chat" },
        },
        v = {
          ["ga"] = { "<cmd>CodeCompanionChat Add<cr>", desc = "Code Companion Add" },
        },
      },
    },
  },
}
