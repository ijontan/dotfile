return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function(opts)
    require('oil').setup {
      win_options = {
        signcolumn = 'yes:2',
      },
      default_file_explorer = true,
      columns = {
        'icon',
        'permissions',
      },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = 'actions.select_vsplit',
        ['<C-h>'] = false,
        ['<C-t>'] = false,
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = false,
        ['<C-l>'] = false,
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = 'actions.tcd',
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
      },
    }
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
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    vim.keymap.set('n', '<C-->', '<C-w>v<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
}
