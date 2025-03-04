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
    ['+'] = 'wl-copy -selection clipboard',
    ['*'] = 'wl-copy -selection primary',
  },
  paste = {
    ['+'] = 'wl-paste -selection clipboard -o',
    ['*'] = 'wl-paste -selection primary -o',
  },
  cache_enabled = 0,
}


local opts = {}

require('lazy').setup 'plugins'
