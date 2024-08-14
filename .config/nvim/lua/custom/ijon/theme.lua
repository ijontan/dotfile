local cyan = '#a5c6ca'
local light_yellow = '#ebdbb2'
local yellow = '#dbbe84'
local orange = '#fcb967'
local red = '#ce6c26'
local green = '#5bd182'
local gray = '#616161'

vim.cmd.highlight { 'String', 'guifg=' .. cyan }
vim.cmd.highlight { 'Normal', 'guibg=#171717' }

vim.cmd.highlight { 'Identifier', 'guifg=' .. light_yellow }

vim.cmd.highlight { 'Constant', 'guifg=' .. yellow }
vim.cmd.highlight { 'Character', 'guifg=' .. yellow }
vim.cmd.highlight { 'Number', 'guifg=' .. yellow }
vim.cmd.highlight { 'Boolean', 'guifg=' .. yellow }
vim.cmd.highlight { 'Float', 'guifg=' .. yellow }
vim.cmd.highlight { 'Float', 'guifg=' .. yellow }

vim.cmd.highlight { 'Operator', 'gui=bold', 'guifg=' .. orange }
vim.cmd.highlight { 'Type', 'guifg=' .. orange }

vim.cmd.highlight { 'Keyword', 'guifg=' .. red }
vim.cmd.highlight { 'Conditional', 'guifg=' .. red }
vim.cmd.highlight { 'Statement', 'guifg=' .. red }
vim.cmd.highlight { 'Repeat', 'guifg=' .. red }
vim.cmd.highlight { 'Label', 'guifg=' .. red }
vim.cmd.highlight { 'Exception', 'guifg=' .. red }

vim.cmd.highlight { 'Comment', 'guifg=' .. gray }
vim.cmd.highlight { 'Define', 'guifg=#d89f24' }
vim.cmd.highlight { 'PreProc', 'guifg=' .. green }
vim.cmd.highlight { 'Macro', 'guifg=' .. green }
vim.cmd.highlight { 'PreCondit', 'guifg=' .. green }
vim.cmd.highlight { 'StorageClass', 'guifg=#d89f24' }
vim.cmd.highlight { 'Structure', 'gui=bold', 'guifg=#d48817' }
vim.cmd.highlight { 'Function', 'gui=italic', 'guifg=' .. green }

vim.cmd.highlight { 'Include', 'gui=italic', 'guifg=' .. orange }

vim.cmd.highlight { 'IlluminatedWordText', 'guibg=#403a30' }
vim.cmd.highlight { 'IlluminatedWordRead', 'guibg=#403a30' }
vim.cmd.highlight { 'IlluminatedWordWrite', 'guibg=#403a30' }
