return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Custom header (ASCII art)
			dashboard.section.header.val = {
				"   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
				"   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
				"   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
				"   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╗██║",
				"   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝██║",
				"   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
			}

			-- Custom buttons
			dashboard.section.buttons.val = {
				dashboard.button("e", "📝 New File", ":ene<CR>"),
				dashboard.button("f", "🔍 Find File", ":Telescope find_files<CR>"), -- Assumes Telescope
				dashboard.button("r", "🕒 Recent Files", ":Telescope oldfiles<CR>"),
				dashboard.button("q", "🚪 Quit", ":qa<CR>"),
			}

			-- Footer (e.g., a quote or version)
			dashboard.section.footer.val = "Neovim - Powered by xAI’s Grok"

			-- Apply the config
			alpha.setup(dashboard.config)

			vim.keymap.set('n', '<leader>a', ':Alpha<CR>', { noremap = true, silent = true })
		end,
	},
}
