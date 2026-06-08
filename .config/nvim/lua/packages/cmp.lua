return {
	"https://github.com/hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"https://github.com/L3MON4D3/LuaSnip",
		"https://github.com/saadparwaiz1/cmp_luasnip",
		"https://github.com/hrsh7th/cmp-nvim-lsp",
		"https://github.com/hrsh7th/cmp-buffer",
		"https://github.com/hrsh7th/cmp-path",
		"https://github.com/onsails/lspkind.nvim",
	},
	setup = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		-- Crucial: Configure completeopt for a better menu experience
		vim.opt.completeopt = { "menu", "menuone", "noselect" }

		cmp.setup({
			-- Link a snippet engine (Required by nvim-cmp)
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			-- Configure your window appearance
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			-- Set up keybindings
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),     -- Manually trigger completion
				["<C-e>"] = cmp.mapping.abort(),            -- Close the completion menu
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept selected item
			}),

			-- Define data sources and their priority order
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- Highest priority
				{ name = "luasnip" }, -- Snippets
				{ name = "buffer" }, -- Text within current file
				{ name = "path" }, -- File system paths
			}),

			-- Optional formatting (requires lspkind.nvim)
			formatting = {
				format = require("lspkind").cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})
	end,
}
