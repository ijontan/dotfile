vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.inccommand = "split"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath('data') .. 'undodir'
vim.opt.undofile = true

vim.opt.clipboard:append('unnamedplus')

vim.opt.guicursor = ""
vim.opt.scrolloff = 8

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight the yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})
