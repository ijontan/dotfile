return {
	'https://github.com/mason-org/mason.nvim',
	lazy = false,
	setup = function()
		require('mason').setup()
	end,
}
