return {
    "nvim-tree/nvim-tree.lua",

    config = function()
        require("nvim-tree").setup({
            view = {
                float = {
                    enable = true,
                    open_win_config = function()
                        return {
                            relative = "editor",
                            border = "none",
                            row = 0,
                            col = 0,
                            width = vim.o.columns,
                            height = vim.o.lines - vim.o.cmdheight,
                        }
                    end,
                },
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
            on_attach = function(bufnr)
                local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end
                local api = require("nvim-tree.api")
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.set("n", "<CR>", api.node.open.tab_drop, opts("Tab drop"))
            end,
            renderer = {
                icons = {
                    show = {
                        file = false,
                        folder = true,
                        folder_arrow = true,
                        git = false,
                        modified = false,
                        hidden = false,
                        diagnostics = false,
                        bookmarks = false,
                    },
                },
            },
        })

        vim.keymap.set("n", "<leader>pv", function()
            require("nvim-tree.api").tree.toggle({ find_file = true })
        end)
    end
}
