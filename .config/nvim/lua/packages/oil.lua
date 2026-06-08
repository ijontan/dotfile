return {
	"https://github.com/stevearc/oil.nvim",
	lazy = false,
	setup = function()
		require("oil").setup(
			{
				win_options = {
					signcolumn = 'yes:2',
				},
				default_file_explorer = true,
				columns = {
					'icon',
					'permissions',
				},
				keymaps = {
					["g?"] = { "actions.show_help", mode = "n" },
					["<CR>"] = "actions.select",
					["<C-s>"] = { "actions.select", opts = { vertical = true } },
					["<C-t>"] = { "actions.select", opts = { tab = true } },
					["<C-p>"] = "actions.preview",
					["<C-c>"] = { "actions.close", mode = "n" },
					["-"] = { "actions.parent", mode = "n" },
					["_"] = { "actions.open_cwd", mode = "n" },
				},
				use_default_keymaps = false,
				view_options = {
					show_hidden = true,
				},
			}
		)

		vim.api.nvim_create_autocmd('VimEnter', {
			callback = vim.schedule_wrap(function(data)
				if vim.bo.filetype == 'nofile' then
					return
				end
				if data.file == '' or vim.fn.isdirectory(data.file) ~= 0 then
					require('oil').open()
				end
			end),
		})

		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		vim.keymap.set('n', '_', '<C-w>v<CMD>Oil<CR>', { desc = 'Open parent directory' })
	end,
}
