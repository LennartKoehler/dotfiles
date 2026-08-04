return {
    "nvim-tree/nvim-tree.lua",

    config = function()
        require("nvim-tree").setup({
            renderer = {
                icons = {
                    show = {
                        file = true,
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
