return {
	"https://github.com/nvim-telescope/telescope.nvim",
	dependencies = {
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	},
	setup = function()
		require('telescope').setup()

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>sn', function()
			builtin.find_files({ cwd = vim.fn.stdpath('config') })
		end, { desc = 'Telescope find config files' })
		vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope live grep' })
		vim.keymap.set('n', '<leader><space>', builtin.builtin, { desc = 'Telescope builtins' })
		vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Telescope help tags' })
		vim.keymap.set('n', '<leader>m', builtin.man_pages, { desc = 'Telescope man pages' })
	end,
}
