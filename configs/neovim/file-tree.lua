local M = {}

function M.setup()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.opt.termguicolors = true

  require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      git_ignored = false,
      dotfiles = false,
    },
  })
end

return M
