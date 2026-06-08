vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'go to definition' })
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'format local buffer' })

vim.diagnostic.config({
	virtual_text = true,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
				}
			},
		},
	},
})
vim.lsp.enable("lua_ls")
