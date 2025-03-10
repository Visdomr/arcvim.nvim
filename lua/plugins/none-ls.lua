return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},

		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {

					require("none-ls.diagnostics.eslint_d"),
					require("none-ls.diagnostics.cpplint"),
					require("none-ls.formatting.jq"),
					require("none-ls.code_actions.eslint"),

					-- Manual luacheck (diagnostics)

					{
						name = "luacheck",
						method = null_ls.methods.DIAGNOSTICS,
						filetypes = { "lua" },
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") .. "/mason/bin/luacheck",
							args = { "--formatter", "plain", "--codes", "$FILENAME" },
							format = "line",
							to_stdin = true,
							from_stderr = true,
							on_output = function(params)
								local diagnostics = {}
								-- Split output into lines
								local lines = vim.split(params.output or "", "\n")
								for _, line in ipairs(lines) do
									-- Match pattern: filename:line:col: message
									local filename, row, col, message = line:match(
										"([^:]+):(%d+):(%d+):%s+(.+)")
									if filename and row and col and message then
										table.insert(diagnostics, {
											filename = filename,
											row = row,
											col = col,
											message = message,
											source = "luacheck",
										})
									end
								end
								return diagnostics
							end,
						}),
					},

					-- Manual black (formatting)
					{
						name = "black",
						method = null_ls.methods.FORMATTING,
						filetypes = { "python" },
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") .. "/mason/bin/black",
							args = { "--quiet", "--fast", "-" },
							to_stdin = true,
						}),
					},
					-- Manual isort (formatting)
					{
						name = "isort",
						method = null_ls.methods.FORMATTING,
						filetypes = { "python" },
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") .. "/mason/bin/isort",
							args = { "--stdout", "--filename", "$FILENAME", "-" },
							to_stdin = true,
						}),
					},
					-- Manual prettier (formatting)
					{
						name = "prettier",
						method = null_ls.methods.FORMATTING,
						filetypes = {
							"javascript", "javascriptreact", "typescript", "typescriptreact",
							"vue", "css", "scss", "less", "html", "json", "jsonc", "yaml",
							"markdown", "markdown.mdx", "graphql", "handlebars", "svelte",
							"astro",
						},
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
							args = { "--stdin-filepath", "$FILENAME" },
							to_stdin = true,
						}),
					},
					-- Manual ruff (diagnostics)
					{
						name = "ruff",
						method = null_ls.methods.DIAGNOSTICS,
						filetypes = { "python" },
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") .. "/mason/bin/ruff",
							args = { "--quiet", "$FILENAME" },
							format = "line",
							to_stdin = false, -- Disable stdin, use file directly
							from_stderr = true,
							on_output = function(params)
								if not params.output then
									return {} -- No diagnostics if no output
								end
								local filename = params.output:match("([^:]+)")
								local row = params.output:match(":(%d+):")
								local col = params.output:match(":%d+:(%d+):")
								local message = params.output:match(":%d+:%d+:%s+(.+)")
								if filename and row and col and message then
									return {
										filename = filename,
										row = row,
										col = col,
										message = message,
										source = "ruff",
									}
								end
								return {}
							end,
						}),
					},


					-- Manual clang_format (formatting)
					{
						name = "clang_format",
						method = null_ls.methods.FORMATTING,
						filetypes = { "c", "cpp", "cs", "java", "cuda", "proto" },
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") .. "/mason/bin/clang-format",
							args = { "--assume-filename", "$FILENAME" },
							to_stdin = true,
						}),
					},
					-- Manual cppcheck (diagnostics)
					{
						name = "cppcheck",
						method = null_ls.methods.DIAGNOSTICS,
						filetypes = { "cpp", "c" },
						generator = null_ls.generator({
							command = "cppcheck", -- Use system PATH instead of Mason
							args = { "--enable=warning,style,performance,portability", "--template=gcc", "$FILENAME" },
							format = "line",
							to_stdin = false,
							from_stderr = true,
							to_temp_file = true,
							on_output = function(params)
								local parser = null_ls.diagnostics.match({
									pattern =
									"([^:]+):(%d+):(%d+):%s+([^%s]+)%s+(.+)",
									groups = { "filename", "row", "col", "severity", "message" },
									overrides = {
										severities = {
											error = 1, -- ERROR
											warning = 2, -- WARNING
											style = 3, -- INFO
											performance = 3, -- INFO
											portability = 3, -- INFO
										},
									},
								})
								return parser(params)
							end,
						}),
					},
					-- Manual eslint (diagnostics)
					{
						name = "eslint_d",
						method = null_ls.methods.DIAGNOSTICS,
						filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") .. "/mason/bin/eslint_d",
							args = { "--stdin", "--stdin-filename", "$FILENAME", "--format", "json" },
							to_stdin = true,
							format = "json",
							on_output = function(params)
								local diagnostics = {}
								local json = params.output
								if json and json[1] and json[1].messages then
									for _, message in ipairs(json[1].messages) do
										table.insert(diagnostics, {
											row = message.line,
											col = message.column,
											message = message.message,
											severity = message.severity == 2 and
											    1 or 2, -- 1=error, 2=warning
											source = "eslint_d",
										})
									end
								end
								return diagnostics
							end,
						}),
					},
					-- Manual shfmt (formatting)
					{
						name = "shfmt",
						method = null_ls.methods.FORMATTING,
						filetypes = { "sh" },
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") .. "/mason/bin/shfmt",
							args = { "-filename", "$FILENAME" },
							to_stdin = true,
						}),
					},
					-- Manual shellcheck (diagnostics)
					{
						name = "shellcheck",
						method = null_ls.methods.DIAGNOSTICS,
						filetypes = { "sh", "bash" },
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") .. "/mason/bin/shellcheck",
							args = { "-f", "gcc", "$FILENAME" },
							format = "line",
							to_stdin = true,
							from_stderr = true,
							on_output = function(params)
								local parser = null_ls.diagnostics.match({
									pattern =
									"([^:]+):(%d+):(%d+):%s+([^:]+):%s+(.+)",
									groups = { "filename", "row", "col", "severity", "message" },
									overrides = {
										severities = {
											error = 1, -- ERROR
											warning = 2, -- WARNING
											note = 3, -- INFO
										},
									},
								})
								return parser(params)
							end,
						}),
					},
					-- Manual stylua (formatting)
					{
						name = "stylua",
						method = null_ls.methods.FORMATTING,
						filetypes = { "lua", "luau" },
						generator = null_ls.generator({
							command = vim.fn.stdpath("data") ..
							    "/home/eric/.local/share/nvim/mason/bin/stylua",
							args = { "--indent-type", "Spaces", "$FILENAME" },
							to_stdin = true,
						}),
					},
				},
			})
			vim.keymap.set("n", "<leader>gf", function()
				local ok, err = pcall(vim.lsp.buf.format)
				if not ok and not string.match(err, "on_output: expected function, got nil") then
					print(err)
				end
			end, {})
		end,
	},
}
