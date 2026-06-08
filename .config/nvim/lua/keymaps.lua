vim.g.mapleader = " "

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without losing yanked text" })

vim.keymap.set("n", "<ESC>", ":nohl<CR>", { desc = "Clear hightlight", silent = true })

-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move selected line up in visual mode"})
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move selected line up in visual mode"})

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Down a page and center" });
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Up a page and center" });

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "navigate to left pane" });
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "navigate to down pane" });
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "navigate to up pane" });
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "navigate to right pane" });

vim.keymap.set("n", "n", "nzzzv", { desc = "Next and center" });
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous and center" });

vim.keymap.set({ "n", "v" }, "<leader>r", [[:%s/<C-r>"//gI<left><left><left>]], { desc = "Replace yanked word with sed" });

vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Previous and center" });
