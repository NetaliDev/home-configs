local M = {}

function M.setup()
  require('editor-settings').setup()
  require('buffer-management').setup()
  require('terminal-settings').setup()
  require('appearance').setup()
  require('file-tree').setup()
  local capabilities = require('completion').setup()
  require('language-servers').setup(capabilities)
end

return M
