---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "yaml",   -- codecompanion, render-markdown
      "html",   -- render-markdown
      "regex",  -- snacks.picker
    },
  },
}
