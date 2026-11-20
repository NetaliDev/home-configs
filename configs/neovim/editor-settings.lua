local M = {}

function M.setup()
  -- Remove trailing whitespace on save
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function(ev)
      save_cursor = vim.fn.getpos(".")
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.setpos(".", save_cursor)
    end,
  })
end

return M
