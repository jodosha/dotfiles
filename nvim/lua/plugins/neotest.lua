return {
  "nvim-neotest/neotest",
  config = function()
    -- get neotest namespace
    local neotest_ns = vim.api.nvim_create_namespace "neotest"
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)
    require("neotest").setup {
      adapters = {
        require "neotest-rust",
        require "neotest-rspec",
        require "neotest-golang" {
          config = function()
            local config = {
              runner = "gotestsum", -- Optional, but recommended
            }
            require("neotest").setup {
              adapters = {
                require "neotest-golang"(config),
              },
            }
          end,
        },
      },
    }
  end,
  ft = { "go", "rust", "ruby" },
  dependencies = {
    "fredrikaverpil/neotest-golang",
    "rouge8/neotest-rust",
    "olimorris/neotest-rspec",
  },
}
