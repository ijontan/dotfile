return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = { -- Example mapping to toggle outline
    { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
  },
  opts = {
    outline_window = {
      position = 'right',
      split_command = 'vs',
      width = 20,
    },
    -- Your setup opts here
    keymaps = { -- These keymaps can be a string or a table for multiple keys
      close = { '<Esc>', 'q' },
      goto_location = '<Cr>',
      focus_location = 'o',
      hover_symbol = '<C-space>',
      toggle_preview = 'K',
      rename_symbol = 'r',
      code_actions = 'a',
      fold = 'h',
      unfold = 'l',
      fold_all = 'W',
      unfold_all = 'E',
      fold_reset = 'R',
    },
  },
}
