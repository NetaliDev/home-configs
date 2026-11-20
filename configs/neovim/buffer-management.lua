local M = {}

function M.setup()
  local map = vim.api.nvim_set_keymap
  local opts = {noremap = true, silent = true}

  -- Move to previous/next
  map('n', '<A-Left>', '<Cmd>BufferPrevious<CR>', opts)
  map('n', '<A-Right>', '<Cmd>BufferNext<CR>', opts)
  -- Re-order to previous/next
  map('n', '<A-S-Left>', '<Cmd>BufferMovePrevious<CR>', opts)
  map('n', '<A-S-Right>', '<Cmd>BufferMoveNext<CR>', opts)
  -- Goto buffer in position...
  map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
  map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
  map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
  map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
  map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
  map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
  map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
  map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
  map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
  map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
  -- Pin/unpin buffer
  map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
  -- Close buffer
  map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
  map('n', '<A-C>', '<Cmd>BufferCloseAllButPinned<CR>', opts)
  -- Wipeout buffer
  --                 :BufferWipeout
  -- Close commands
  --                 :BufferCloseAllButCurrent
  --                 :BufferCloseAllButPinned
  --                 :BufferCloseAllButCurrentOrPinned
  --                 :BufferCloseBuffersLeft
  --                 :BufferCloseBuffersRight
  -- Sort automatically by...
  map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
  map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
  map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
  map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

  -- Other:
  -- :BarbarEnable - enables barbar (enabled by default)
  -- :BarbarDisable - very bad command, should never be used

  vim.g.barbar_auto_setup = false

  require'barbar'.setup {
    animation = true,
    auto_hide = false,
    tabpages = true,
    clickable = true,
    focus_on_close = 'left',
    hide = {extensions = false, inactive = false},
    highlight_alternate = false,
    highlight_inactive_file_icons = false,
    highlight_visible = true,
    icons = {
      buffer_index = false,
      buffer_number = false,
      button = "",
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ﬀ'},
        [vim.diagnostic.severity.WARN] = {enabled = false},
        [vim.diagnostic.severity.INFO] = {enabled = false},
        [vim.diagnostic.severity.HINT] = {enabled = true}
      },
      gitsigns = {
        added = {enabled = true, icon = '+'},
        changed = {enabled = true, icon = '~'},
        deleted = {enabled = true, icon = '-'}
      },
      filetype = {
        -- Sets the icon's highlight group.
        -- If false, will use nvim-web-devicons colors
        custom_colors = false,

        -- Requires `nvim-web-devicons` if `true`
        enabled = true
      },
      separator = {left = '▎', right = ""},
      separator_at_end = true,
      modified = {button = '●'},
      pinned = {button = '', filename = true},

      -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
      preset = 'default',
      alternate = {filetype = {enabled = false}},
      current = {buffer_index = true},
      inactive = {button = ""},
      visible = {modified = {buffer_number = false}}
    },

    -- If true, new buffers will be inserted at the start/end of the list.
    -- Default is to insert after current buffer.
    insert_at_end = false,
    insert_at_start = false,
    maximum_padding = 1,
    minimum_padding = 1,
    maximum_length = 30,
    minimum_length = 0,
    semantic_letters = true,
    sidebar_filetypes = {
      -- Use the default values: {event = 'BufWinLeave', text = nil}
      NvimTree = true,
      -- Or, specify the text used for the offset:
      undotree = {text = 'undotree'},
      -- Or, specify the event which the sidebar executes when leaving:
      ['neo-tree'] = {event = 'BufWipeout'},
      -- Or, specify both
      Outline = {event = 'BufWinLeave', text = 'symbols-outline'}
    },

    -- New buffer letters are assigned in this order. This order is
    -- optimal for the qwerty keyboard layout but might need adjustment
    -- for other layouts.
    letters = 'asdfjkl;ghnmxcvbyiowerutzqpASDFJKLGHNMXCVBZIOWERUTZQP'
  }
end

return M
