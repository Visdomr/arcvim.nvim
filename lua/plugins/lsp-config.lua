return {
	{
		'williamboman/mason.nvim',
		config = function()
			require('mason').setup()
			ensure_installed = {
				-- LSP servers, formatters, and linters all go here
				'lua_ls',
				'bashls',
				'pkgbuild_language_server',
				'clangd',
				'html',
				'htmx',
				'kotlin_language_server',
				'pylsp',
				'tsp_server',
				'lemminAnimx',
				'yamlls',
				'black',
				'ruff',
				'clang-format',
				'cppcheck',
				'stylua',
				'luacheck',
				'prettier',
				'eslint_d',
				'shfmt',
				'shellcheck',
			}
		end,
	},
	{
		'williamboman/mason-lspconfig.nvim',
		config = function()
			require('mason-lspconfig').setup {
				ensure_installed = { 'lua_ls', 'ts_ls', 'bashls', 'clangd', 'html', 'htmx', 'kotlin_language_server', 'pylsp', 'tsp_server', 'lemminx', 'yamlls' },
			}
		end,
	},
	{
		'neovim/nvim-lspconfig',
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			local lspconfig = require 'lspconfig'
			lspconfig.lua_ls.setup({
			  capabilities = capabilities
			})
			lspconfig.ts_ls.setup({
			  capabilities = capabilities
			})
			lspconfig.bashls.setup({
			  capabilities = capabilities
			})
			lspconfig.clangd.setup({
			  capabilities = capabilities
			})
			lspconfig.html.setup({
			  capabilities = capabilities
			})
			lspconfig.htmx.setup({
			  capabilities = capabilities
			})
			lspconfig.kotlin_language_server.setup({
			  capabilities = capabilities
			})
			lspconfig.pylsp.setup({
			  capabilities = capabilities
			})
			lspconfig.tsp_server.setup({
			  capabilities = capabilities
			})
			lspconfig.lemminx.setup({
			  capabilities = capabilities
			})
			lspconfig.yamlls.setup({
			  capabilities = capabilities
			})

			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
			vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
		end,
	},
}
