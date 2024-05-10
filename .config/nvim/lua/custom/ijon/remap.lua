vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.keymap.set("n", "<C-d>", "<C-d>zz");
-- vim.keymap.set("n", "<C-u>", "<C-u>zz");

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = '[P]aste without yanking' })
vim.keymap.set("n", "<leader>=", "<C-w>=")
vim.keymap.set("n", "<leader>m", "<C-w>|")

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = '[F]ormat current file' })
vim.keymap.set("n", "<leader>v", vim.cmd.vsplit, { desc = '[V]ertically split window' })
vim.keymap.set("n", "<C-c>", vim.cmd.close, { desc = '[C]lose current window' })

