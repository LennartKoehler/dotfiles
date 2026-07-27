return{

    "echasnovski/mini.nvim",
    config = function()
        require("mini.test").setup()

        local statusline = require("mini.statusline")
        statusline.setup({
            use_icons = true,
            content = {
                active = function()
                    local filename = statusline.section_filename({ trunc_width = 140 })

                    local git = ""
                    if vim.fn.exists("*FugitiveHead") == 1 then
                        local head = vim.fn.FugitiveHead()
                        if head ~= "" then
                            local icon = require("codicons").get("git-branch", "icon")
                            git = " " .. icon .. " " .. head
                        end
                    end

                    return statusline.combine_groups({
                        { hl = "MiniStatuslineDevinfo",  strings = { git } },
                        "%<",
                        { hl = "MiniStatuslineFilename", strings = { filename } },
                        "%=",
                    })
                end,
                inactive = function()
                    local filename = statusline.section_filename({ trunc_width = 140 })
                    return statusline.combine_groups({
                        { hl = "MiniStatuslineFilename", strings = { filename } },
                    })
                end,
            },
        })
    end,
    lazy = false,
}

