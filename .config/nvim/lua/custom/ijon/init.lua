vim.cmd.set { 'tabstop=4' }
vim.cmd.set { 'softtabstop=4' }
vim.cmd.set { 'shiftwidth=4' }
vim.cmd.set { 'preserveindent' }
vim.cmd.set { 'copyindent' }
vim.cmd.set { 'noexpandtab' }

vim.cmd.set { 'relativenumber' }
vim.cmd.set { 'nowrap' }

vim.g.user42 = 'itan'
vim.g.user42mail = 'itan@student.42.fr'

require 'custom.ijon.remap'
require 'custom.ijon.theme'
