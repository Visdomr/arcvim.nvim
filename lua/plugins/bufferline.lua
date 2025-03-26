return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.opt.termguicolors = true -- Enable true colors (move this here or to init.lua)
			require("bufferline").setup {}
		end,
	},
}
