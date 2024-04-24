return {
  'm00qek/baleia.nvim',
  enabled = true,
  cmd = {
    'BaleiaLess'
  },
  config = function ()
    local baleia = require('baleia').setup()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_create_user_command('BaleiaLess', function ()
      vim.bo.buftype = 'nofile'
      vim.bo.bufhidden = 'wipe'
      vim.bo.swapfile = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.cursorline = false
      vim.opt.termguicolors = true
      vim.opt_local.laststatus = 0
      vim.opt_local.cmdheight = 0
      vim.opt_local.scrolloff = 0
      vim.opt_local.showmode = true

      baleia.once(vim.fn.bufnr(bufnr))
    end, {})
  end
}
