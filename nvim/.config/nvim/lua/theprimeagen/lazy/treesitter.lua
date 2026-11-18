return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false, -- main branch does not support lazy-loading
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter").setup({})

			-- no-op if already installed; keeps parsers in sync on startup
			require("nvim-treesitter").install({
				"bash",
				"c",
				"c_sharp",
				"comment",
				"cpp",
				"go",
				"java",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"templ",
				"vimdoc",
				"yaml",
			})

			-- highlighting + experimental treesitter indent
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang or not vim.treesitter.language.add(lang) then
						return
					end

					vim.treesitter.start(args.buf, lang)

					-- only set indentexpr when the language ships an `indents` query
					local has_indents, indents = pcall(vim.treesitter.query.get, lang, "indents")
					if has_indents and indents then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		after = "nvim-treesitter",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				multiwindow = false, -- Enable multiwindow support.
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
		end,
	},
}
