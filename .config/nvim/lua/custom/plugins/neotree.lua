return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    require('neo-tree').setup {
      filesystem = {
        filtered_items = {
          visible = true,
        }
      },
      default_component_configs = {
        indent = {
          indent_size = 1;
          padding = 1
        }
      },
      window = {
        position = "right",
        width = 25
      }
    }
  end,
}
