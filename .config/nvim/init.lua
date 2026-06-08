require('vim._core.ui2').enable({})

require('settings')
require('keymaps')
require('pack')
require('lsp') -- has to be after package load
require('commands')
require('colorscheme')
