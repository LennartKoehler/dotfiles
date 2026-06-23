-- test comment
local _current_model = "vllm/frontier"

-- Available models
local available_models = {
    "vllm/coder",
    "vllm/multimodal",
    "vllm/frontier",
    "vllm/qwen3-embedding-8b",
}

local function print_available_models()
    local lines = {}
    for _, model in ipairs(available_models) do
        local marker = model == _current_model and "  [CURRENT]" or "             "
        table.insert(lines, { "  - " .. model .. marker, "Normal" })
    end
    vim.api.nvim_echo(lines, true, {})
end

local function set_model(model_name)
    _current_model = model_name
    vim.notify("Model set to: " .. model_name, vim.log.levels.INFO)
end

-- Expose globally so you can call :SetModel from Neovim
_G.set_llm_model = set_model

-- Command to set model
vim.api.nvim_create_user_command("CodeCompanionSetModel", function(opts)
    if opts.args and opts.args ~= "" then
        set_model(opts.args)
    else
        vim.notify("Usage: :CodeCompanionSetModel <model-name>", vim.log.levels.WARN)
    end
end, { nargs = "?" })

-- Command to list available models
vim.api.nvim_create_user_command("CodeCompanionListModels", function()
    print_available_models()
end, { nargs = 0 })



return {
    -- "codecompanion",
    -- dir = "~/projects/codecompanion.nvim",
    "olimorris/codecompanion.nvim",
    -- "LennartKoehler/codecompanion.nvim",
    -- version = "^19.0.0",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        { "<leader>cc", "<cmd>CodeCompanion /default<cr>", desc = "Code Companion Chat" },
        { "<leader>ca", "<cmd>CodeCompanion /defaultagent<cr>", desc = "Code Companion Agent" },
        { "<leader>co", "<cmd>CodeCompanion /opencodeagent<cr>", desc = "Code Companion OpenCode ACP" },
        { "<leader>cy", "<cmd>CodeCompanionChat<cr>", desc = "Run Test Prompt" },
    },

    -- opts = {
    --     opts = {
    --         log_level = "TRACE", -- or "TRACE"
    --     },
    -- },
    config = function()

        local adapters = require("codecompanion.adapters")
        require("codecompanion").setup({
          opts = {
            log_level = "TRACE", -- or "TRACE"
          },
              display = {
                diff = {
                  -- Diffs with fewer lines than this are shown directly in the chat buffer
                  -- Diffs with more lines automatically open in a floating window
                  threshold_for_chat = 0, -- adjust this number to your preference
                },
              },
            interactions = {
                chat = {
                    adapter = "local_llm",
                  opts = {
                    completion_provider = "cmp",
                  }
                },
              },
            autocomplete = false,
            debug = true,
            adapters = {
                http = {
                    local_llm = adapters.extend("openai_compatible", {
                        name = "local_llm",
                        tools = adapters.USAGE_ADAPTER_TOOLS,
                        formatted_name = "Local LLM",
                        roles = { system = "system", user = "user", assistant = "assistant" },
                        env = {
                            api_key = "LOCAL_LLM_API_KEY",
                            base_url = "LOCAL_LLM_URL",
                        },
                        url = "${base_url}",
                        schema = {
                            model = {
                                default = function()
                                    return _current_model
                                end,
                            },
                        },
                    }),
                },
                acp = {
                    opencode = function()
                        return require("codecompanion.adapters").extend("opencode", {})
                    end,
                },
            },


            prompt_library = {
                markdown = {
                    dirs = {
                        "~/.config/nvim/lua/prompts",
                    }
                }
            }
        })


    end,

}

