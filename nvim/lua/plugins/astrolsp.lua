-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- Function to check if an LSP server is available in PATH
local function is_lsp_available(server_name)
  local handle = io.popen("which " .. server_name .. " 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
  end
  return false
end

-- Function to get all available LSP servers
local function get_available_servers()
  -- Always include globally configured servers
  local global_servers = {
    "lua_ls",     -- Lua Language Server (from Nix)
    "nil_ls",     -- Nix Language Server (from Nix)
    "nixd",       -- Alternative Nix Language Server (from Nix)
    "solargraph", -- Ruby Language Server (from Nix global)
  }

  -- Project-specific servers to check dynamically
  local project_servers = {
    -- Python
    "pyright",
    "ruff_lsp", -- ruff can be used as LSP server

    -- JavaScript/TypeScript
    "ts_ls",    -- typescript-language-server (renamed from tsserver in Neovim 0.11+)
    "html",     -- from vscode-langservers-extracted
    "cssls",    -- from vscode-langservers-extracted
    "jsonls",   -- from vscode-langservers-extracted

    -- Go
    "gopls",

    -- Rust
    "rust_analyzer",

    -- Ruby (additional to global)
    "ruby_lsp",
  }

  local available_servers = {}

  -- Add global servers (these should always be available)
  for _, server in ipairs(global_servers) do
    table.insert(available_servers, server)
  end

  -- Check project-specific servers dynamically
  for _, server in ipairs(project_servers) do
    local binary_name = server
    -- Map LSP server names to their actual binary names
    if server == "ts_ls" then
      binary_name = "typescript-language-server"
    elseif server == "rust_analyzer" then
      binary_name = "rust-analyzer"
    elseif server == "ruff_lsp" then
      binary_name = "ruff"
    elseif server == "html" or server == "cssls" or server == "jsonls" then
      binary_name = "vscode-langservers-extracted"
    end

    if is_lsp_available(binary_name) then
      table.insert(available_servers, server)
    end
  end

  return available_servers
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
    },
    -- enable servers that you already have installed without mason
    -- Use dynamic detection to include both global and project-specific servers
    servers = get_available_servers(),
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }, -- Recognize vim global in NeoVim config
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      },
      nil_ls = {
        settings = {
          ["nil"] = {
            testSetting = 42,
            formatting = {
              command = { "nixfmt" }, -- Use nixfmt for formatting
            },
          },
        },
      },
      nixd = {
        cmd = { "nixd" },
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      },
      solargraph = {
        settings = {
          solargraph = {
            diagnostics = true,
            completion = true,
            hover = true,
            symbols = true,
            definitions = true,
            references = true,
            rename = true,
            folding = true,
            formatting = true,
          },
        },
      },
      -- Python LSP servers
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
            },
          },
        },
      },
      ruff_lsp = {
        init_options = {
          settings = {
            -- Arguments to pass to the ruff executable
            args = {},
          },
        },
      },
      -- JavaScript/TypeScript LSP servers
      ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "literal",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      },
      -- Go LSP server
      gopls = {
        settings = {
          gopls = {
            -- Formatting settings
            gofumpt = true,

            -- Code lenses
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },

            -- Inlay hints
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },

            -- Static analysis (removed fieldalignment as it's deprecated)
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },

            -- Completion and import settings
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,

            -- Directory filters
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-server", "-node_modules" },

            -- UI settings
            semanticTokens = true,
            importShortcut = "Both",
            symbolMatcher = "FastFuzzy",
            matcher = "Fuzzy",
            symbolStyle = "Dynamic",

            -- Workspace settings
            expandWorkspaceToModule = true,
          },
        },
      },
      -- Rust LSP server
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      -- Additional Ruby LSP server
      ruby_lsp = {
        init_options = {
          formatter = "auto",
        },
      },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
      -- Auto-detect LSP servers when entering directories (useful for Nix dev shells)
      lsp_server_detection = {
        {
          event = { "DirChanged", "VimEnter" },
          desc = "Detect available LSP servers when changing directories",
          callback = function()
            -- Small delay to allow environment to settle
            vim.defer_fn(function()
              local available_servers = get_available_servers()
              -- Update the configuration with newly available servers
              local astrolsp = require("astrolsp")
              if astrolsp and astrolsp.config then
                astrolsp.config.servers = available_servers
              end
            end, 100)
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
        -- Custom mappings for LSP server management
        ["<Leader>lR"] = {
          function()
            local available_servers = get_available_servers()
            vim.notify("Refreshed LSP servers. Available: " .. table.concat(available_servers, ", "), vim.log.levels.INFO)

            -- Update the configuration
            local astrolsp = require("astrolsp")
            if astrolsp and astrolsp.config then
              astrolsp.config.servers = available_servers
            end

            -- Restart LSP clients for current buffer
            vim.cmd("LspRestart")
          end,
          desc = "Refresh and restart LSP servers",
        },
        ["<Leader>lS"] = {
          function()
            local available_servers = get_available_servers()
            local active_clients = vim.lsp.get_clients()

            local info = {
              "=== LSP Server Status ===",
              "",
              "Available servers: " .. table.concat(available_servers, ", "),
              "",
              "Active clients:",
            }

            for _, client in ipairs(active_clients) do
              table.insert(info, "  - " .. client.name .. " (ID: " .. client.id .. ")")
            end

            vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
          end,
          desc = "Show LSP server status",
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr) end,
  },
  -- Add configuration callback to set up custom commands
  config = function(plugin, opts)
    -- Call the default AstroLSP setup
    require("astrolsp").setup(opts)

    -- Add custom user commands for LSP server management
    vim.api.nvim_create_user_command("LspRefresh", function()
      local available_servers = get_available_servers()
      vim.notify("Refreshed LSP servers. Available: " .. table.concat(available_servers, ", "), vim.log.levels.INFO)

      -- Update the configuration
      local astrolsp = require("astrolsp")
      if astrolsp and astrolsp.config then
        astrolsp.config.servers = available_servers
      end

      -- Restart LSP clients for all buffers
      vim.cmd("LspRestart")
    end, {
      desc = "Refresh available LSP servers and restart clients",
      bang = true
    })

    vim.api.nvim_create_user_command("LspStatus", function()
      local available_servers = get_available_servers()
      local active_clients = vim.lsp.get_clients()

      local info = {
        "=== LSP Server Status ===",
        "",
        "Available servers (" .. #available_servers .. "):",
      }

      for _, server in ipairs(available_servers) do
        local binary_name = server
        -- Map server names to binary names for status display
        if server == "ts_ls" then
          binary_name = "typescript-language-server"
        elseif server == "rust_analyzer" then
          binary_name = "rust-analyzer"
        elseif server == "ruff_lsp" then
          binary_name = "ruff"
        end

        local status = is_lsp_available(binary_name) and "✓" or "✗"
        table.insert(info, "  " .. status .. " " .. server .. " (" .. binary_name .. ")")
      end

      table.insert(info, "")
      table.insert(info, "Active clients (" .. #active_clients .. "):")

      if #active_clients == 0 then
        table.insert(info, "  (none)")
      else
        for _, client in ipairs(active_clients) do
          local buffers = {}
          for _, buf in ipairs(vim.lsp.get_buffers_by_client_id(client.id)) do
            local bufname = vim.api.nvim_buf_get_name(buf)
            local filename = vim.fn.fnamemodify(bufname, ":t")
            if filename ~= "" then
              table.insert(buffers, filename)
            end
          end
          local buffer_info = #buffers > 0 and " [" .. table.concat(buffers, ", ") .. "]" or ""
          table.insert(info, "  - " .. client.name .. " (ID: " .. client.id .. ")" .. buffer_info)
        end
      end

      vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
    end, {
      desc = "Show detailed LSP server status",
      bang = true
    })
  end,
}
