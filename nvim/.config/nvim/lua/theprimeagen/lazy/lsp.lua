return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "p00f/clangd_extensions.nvim",
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "Hoffs/omnisharp-extended-lsp.nvim",
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "marksman",
                "clangd",
                "basedpyright",
                "clangd",
                "jdtls",
                "omnisharp",
            },

            automatic_enable = {
                exclude = { "omnisharp" },
            },

            handlers = {
                function(server_name) -- default handler
                    if server_name ~= "clangd" then
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end
                end,

                -- clangd setup
                ["clangd"] = function()

                    capabilities = require("cmp_nvim_lsp").default_capabilities()
                    require("clangd_extensions").setup({
                            server = {
                                capabilities = capabilities,
                                filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "cu", "cuh" },
                                handlers = {
                                    ["textDocument/semanticTokens/full"] = function(...) end
                                },
                                cmd = { "clangd", "--compile-commands-dir=build", "--xcuda" },
                                root_dir = require("lspconfig").util.root_pattern("compile_commands.json", ".git"),
                                init_options = {
                                    compilationDatabasePath = "build",
                                    clangdFileStatus = true,
                                },
                            }
                        })
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,

                ["basedpyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.basedpyright.setup({
                        capabilities = capabilities,
                        settings = {
                            basedpyright = {
                                analysis = {
                                    diagnosticMode = 'openFilesOnly',
                                    typeCheckingMode = 'basic',
                                    useLibraryCodeForTypes = true,
                                    diagnosticSeverityOverrides = {
                                        autoSearchPaths = true,
                                        enableTypeIgnoreComments = false,
                                        reportGeneralTypeIssues = 'none',
                                        reportArgumentType = 'none',
                                        reportUnknownMemberType = 'none',
                                        reportAssignmentType = 'none',
                                    },
                                },
                            },
                        },
                    })
                end,

                ["jdtls"] = function()
                    local lspconfig = require("lspconfig")
                    local mason_registry = require("mason-registry")

                    local bundles = {}

                    local java_debug = mason_registry.get_package("java-debug-adapter")
                    if java_debug:is_installed() then
                        local path = java_debug:get_install_path()
                        for _, jar in ipairs(vim.fn.glob(path .. "/server/com.microsoft.java.debug.plugin-*.jar", false, true)) do
                            table.insert(bundles, jar)
                        end
                    end

                    local java_test = mason_registry.get_package("java-test")
                    if java_test:is_installed() then
                        local path = java_test:get_install_path()
                        for _, jar in ipairs(vim.fn.glob(path .. "/server/*.jar", false, true)) do
                            table.insert(bundles, jar)
                        end
                    end

                    lspconfig.jdtls.setup({
                        capabilities = capabilities,
                        root_dir = lspconfig.util.root_pattern(
                            ".git", "mvnw", "gradlew", "pom.xml",
                            "build.gradle", "build.gradle.kts",
                            "settings.gradle", "settings.gradle.kts",
                            "build.xml"
                        ),
                        init_options = {
                            bundles = bundles,
                        },
                        settings = {
                            java = {
                                signatureHelp = { enabled = true },
                                contentProvider = { preferred = 'fernflower' },
                            },
                        },
                    })
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT',
                                },
                                diagnostics = {
                                    globals = { 'vim' },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                                format = {
                                    enable = true,
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    }
                                },
                            }
                        }
                    }
                end,

                ["tailwindcss"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.tailwindcss.setup({
                        capabilities = capabilities,
                        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "heex" },
                    })
                end,
            }
        })

        local omnisharp_ext = require("omnisharp_extended")
        local omnisharp_rpc = require("vim.lsp.rpc")

        -- OmniSharp can only load projects via the .NET-SDK MSBuild. Legacy
        -- non-SDK projects (e.g. .NET Framework 4.x WinForms) fail to load and
        -- give no navigation. A project can ship an SDK-style wrapper solution
        -- under <root>/.lsp/*.lsp.sln that references the real sources in place;
        -- when present we point OmniSharp at it with -s (the only steering
        -- lever in LSP mode). Without it, the stock command is used.
        local function omnisharp_cmd(dispatchers, config)
            local cmd = {
                "OmniSharp",
                "-z",
                "--hostPID",
                tostring(vim.fn.getpid()),
                "DotNet:enablePackageRestore=false",
                "--encoding",
                "utf-8",
            }
            local root = config.root_dir
            if root then
                local wrappers = vim.fn.glob(root .. "/.lsp/*.lsp.sln", false, true)
                if #wrappers > 0 then
                    table.insert(cmd, "-s")
                    table.insert(cmd, wrappers[1])
                end
            end
            table.insert(cmd, "--languageserver")
            return omnisharp_rpc.start(cmd, dispatchers, {
                cwd = config.cmd_cwd,
                env = config.cmd_env,
                detached = config.detached,
            })
        end

        vim.lsp.config("omnisharp", {
            cmd = omnisharp_cmd,
            capabilities = capabilities,
            handlers = {
                ["textDocument/definition"] = omnisharp_ext.definition_handler,
                ["textDocument/typeDefinition"] = omnisharp_ext.type_definition_handler,
                ["textDocument/references"] = omnisharp_ext.references_handler,
                ["textDocument/implementation"] = omnisharp_ext.implementation_handler,
            },
            on_attach = function(_, bufnr)
                local opts = { buffer = bufnr, silent = true, noremap = true }
                vim.keymap.set("n", "gd", function()
                    omnisharp_ext.lsp_definition()
                end, opts)
                vim.keymap.set("n", "gD", function()
                    omnisharp_ext.lsp_type_definition()
                end, opts)
                vim.keymap.set("n", "gr", function()
                    omnisharp_ext.lsp_references()
                end, opts)
                vim.keymap.set("n", "gI", function()
                    omnisharp_ext.lsp_implementation()
                end, opts)
            end,
        })
        vim.lsp.enable("omnisharp")

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({

            enabled = function()
                -- Disable cmp when in the codecompanion buffer
                if vim.bo.filetype == "codecompanion"  or vim.bo.filetype == "telescopeprompt" or vim.bo.filetype == "markdown" then
                    return false
                end
                return true
            end,
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                    { name = 'buffer' },
                })
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}

