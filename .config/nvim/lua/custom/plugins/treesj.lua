return {
	"Wansmer/treesj",
	keys = {
		{
			"<leader>j",
			"<CMD>TSJToggle<CR>",
			desc = "Toggle treesitter [J]oin"
		}
	},
	cmd = { "TSJToggle", "TSJSplit", "TsJJoin" },
	opts = { use_default_keymaps = false }
}
