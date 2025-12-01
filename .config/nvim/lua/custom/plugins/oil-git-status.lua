return {
  'refractalize/oil-git-status.nvim',
  dependencies = {
    'stevearc/oil.nvim',
  },
  config = function()
    require('oil-git-status').setup {
      show_ignored = true, -- show files that match gitignore with !!
      symbols = { -- customize the symbols that appear in the git status columns
        index = {
          ['!'] = '!',
          ['?'] = '?',
          ['A'] = '┃',
          ['C'] = '┃',
          ['D'] = '',
          ['M'] = '┃',
          ['R'] = 'R',
          ['T'] = 'T',
          ['U'] = 'U',
          [' '] = ' ',
        },
        working_tree = {
          ['!'] = '!',
          ['?'] = '?',
          ['A'] = '┃',
          ['C'] = '┃',
          ['D'] = '',
          ['M'] = '┃',
          ['R'] = 'R',
          ['T'] = 'T',
          ['U'] = 'U',
          [' '] = ' ',
        },
      },
    }
    for _, hl_group in pairs(require('oil-git-status').highlight_groups) do
      local switch = {
        ['!'] = 'GruvboxRed',
        ['?'] = 'GruvboxRed',
        ['A'] = 'GruvboxGreen',
        ['C'] = 'GruvboxOrange',
        ['D'] = 'GruvboxRed',
        ['M'] = 'GruvboxOrange',
        ['R'] = 'GruvboxOrange',
        ['T'] = 'GruvboxGreen',
        ['U'] = 'GruvboxGreen',
        [' '] = '',
      }
      local link = switch[hl_group.status_code]
      vim.api.nvim_set_hl(0, hl_group.hl_group, { link = link })
    end
  end,
}
