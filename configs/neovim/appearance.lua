local M = {}

function M.setup()
  require("nvim-web-devicons").setup {
    color_icons = true;
    default = true;
  }

  local dracula = require("dracula")
  dracula.setup({
    colors = {
      nontext = "#949597",
    }
  })

  vim.cmd [[colorscheme dracula]]
end

return M
