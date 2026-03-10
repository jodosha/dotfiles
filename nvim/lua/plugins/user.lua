---@type LazySpec
return {
  {
    dir = "/Users/jodosha/Code/jodosha/ki/nvim-ki",
    ft = "ki",
  },
  {
    "Cannon07/claude-preview.nvim",
    config = function() require("claude-preview").setup() end,
  },
}
