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
          ["<Leader>eg"] = { ":Neotree source=git_status reveal=true<cr>", desc = "Show Neo-Tree Git status" },
          ["<Leader>rs"] = { ":TermExec cmd='bundle exec rspec %' direction='float'<cr>", desc = "RSpec file" },
          ["<Leader>rsl"] = {
            function()
              local line_num = vim.fn.line "."
              vim.cmd("TermExec cmd='bundle exec rspec %:" .. line_num .. "' direction='float'")
            end,
            desc = "RSpec line",
          },
        },
      },
    },
  },
}
