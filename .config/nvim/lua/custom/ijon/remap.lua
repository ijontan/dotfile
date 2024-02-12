vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = '[F]ormat current file' })

vim.keymap.set("n", "<leader>n", function()
  local find_buffer_by_type = function(type)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local ft = vim.api.nvim_buf_get_option(buf, "filetype")
      if ft == type then return buf end
    end
    return -1
  end
  local toggle_neotree = function()
    if find_buffer_by_type "neo-tree" > 0 then
      require("neo-tree.command").execute { action = "close" }
    else
      require("neo-tree.command").execute { reveal = true }
    end
  end
  toggle_neotree()
end, { desc = 'Toggle [N]eotree' })
