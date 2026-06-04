-- In AstroNvim v6, nvim-treesitter moved to its `main` branch and acts purely as a
-- parser-download utility. Highlighting, textobjects, and parser management are now
-- configured through AstroCore's `treesitter` table (`:h astrocore`).
---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      ensure_installed = {
        "lua",
        "vim",
        "yaml", -- codecompanion, render-markdown
        "html", -- render-markdown
        "regex", -- snacks.picker
        "go",
        "gomod",
        "gosum",
        "gowork",
        "rust",
        "python",
        "markdown", -- for markdown code blocks
        "toml",
      },
      highlight = true,
    },
  },
}
