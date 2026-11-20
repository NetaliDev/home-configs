local M = {}

function M.setup()
  require("toggleterm").setup {
    open_mapping = [[<A-Space>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
    direction = 'horizontal',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell,
    auto_scroll = true, -- automatically scroll to the bottom on terminal output
    -- This field is only relevant if direction is set to 'float'
    winbar = {
      enabled = false,
      name_formatter = function(term) --  term: Terminal
        return term.name
      end
    },
  }
end

return M
