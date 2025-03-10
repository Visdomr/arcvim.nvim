local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.clipboard = {
  name = 'wl-clipboard',
  copy = {
    ['+'] = 'wl-copy',
    ['*'] = 'wl-copy',
  },
  paste = {
    ['+'] = 'wl-paste',
    ['*'] = 'wl-paste',
  },
  cache_enabled = 0,
}

-- Normal mode keybindings
vim.keymap.set('n', '<C-f>', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-b>', ':bprev<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>wq', ':wall | qall<CR>', { noremap = true, silent = true })

local opts = {}

require('lazy').setup 'plugins'
