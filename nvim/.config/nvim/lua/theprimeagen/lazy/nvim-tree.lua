return {
    "nvim-tree/nvim-tree.lua",

    config = function()
        require("nvim-tree").setup({
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
            require("nvim-tree.api").tree.toggle()
        end)
    end
}
