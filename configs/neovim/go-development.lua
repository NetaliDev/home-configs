local M = {}

function M.setup(capabilities)
  vim.g.sleuth_go_heuristics = 0
  vim.lsp.config('gopls', {
    capabilities = capabilities,
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        staticcheck = true,
        analyses = { unusedparams = true },
      },
    },
  })
  vim.lsp.enable('gopls')

  local group = vim.api.nvim_create_augroup('GoDevelopment', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = group,
    pattern = '*.go',
    callback = function(ev)
      -- Both requests must finish before the buffer is written to disk.
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = ev.buf, name = 'gopls' })) do
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
        local response, err = client:request_sync('textDocument/codeAction', params, 3000, ev.buf)
        if err or (response and response.err) then
          vim.notify('Go imports: ' .. vim.inspect(err or response.err), vim.log.levels.WARN)
        end
        for _, action in ipairs((response and response.result) or {}) do
          if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
          end
        end
        vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, async = false, timeout_ms = 3000 })
      end
    end,
  })

  local neotest = require('neotest')
  neotest.setup({
    adapters = { require('neotest-go')({ args = { '-count=1' }, recursive_run = true }) },
  })

  -- Use the nearest module for commands, including modules inside a go.work workspace.
  local function module_root()
    return vim.fs.root(0, 'go.mod') or vim.fs.root(0, 'go.work') or vim.fn.getcwd()
  end

  local function run_go(args, cwd)
    vim.cmd.update()
    local command = { 'go' }
    vim.list_extend(command, args)
    command = table.concat(vim.tbl_map(vim.fn.shellescape, command), ' ')
    require('toggleterm.terminal').Terminal:new({
      cmd = command,
      dir = cwd or module_root(),
      close_on_exit = false,
    }):toggle()
  end

  local commands = {
    GoBuild = { 'build', './...' },
    GoVet = { 'vet', './...' },
    GoTestSuite = { 'test', '-count=1', './...' },
    GoCoverage = { 'test', '-cover', './...' },
    GoModTidy = { 'mod', 'tidy' },
  }
  for name, args in pairs(commands) do
    vim.api.nvim_create_user_command(name, function() run_go(args) end, { desc = 'go ' .. table.concat(args, ' ') })
  end
  vim.api.nvim_create_user_command('GoRun', function()
    run_go({ 'run', '.' }, vim.fn.expand('%:p:h'))
  end, { desc = 'Run the current Go package' })

  local dap = require('dap')
  local dapui = require('dapui')
  require('dap-go').setup()
  dapui.setup()
  dap.listeners.after.event_initialized['go-development'] = function() dapui.open() end
  dap.listeners.before.event_terminated['go-development'] = function() dapui.close() end
  dap.listeners.before.event_exited['go-development'] = function() dapui.close() end

  local function key(lhs, rhs, desc, buffer)
    vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc, buffer = buffer })
  end
  key('<F5>', dap.continue, 'Debug: start / continue')
  key('<F10>', dap.step_over, 'Debug: step over')
  key('<F11>', dap.step_into, 'Debug: step into')
  key('<F12>', dap.step_out, 'Debug: step out')
  key('<space>db', dap.toggle_breakpoint, 'Debug: toggle breakpoint')
  key('<space>dB', function()
    vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(condition)
      if condition and condition ~= '' then dap.set_breakpoint(condition) end
    end)
  end, 'Debug: conditional breakpoint')
  key('<space>du', dapui.toggle, 'Debug: toggle UI')
  key('<space>de', dapui.eval, 'Debug: evaluate expression')
  key('<space>dq', dap.terminate, 'Debug: terminate')

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'go', 'gomod', 'gowork', 'gosum' },
    callback = function(ev)
      vim.treesitter.start(ev.buf)
      if vim.bo[ev.buf].filetype ~= 'go' then return end
      -- Go uses tabs; override the global expandtab and vim-sleuth defaults.
      vim.bo[ev.buf].expandtab = false
      vim.bo[ev.buf].tabstop = 4
      vim.bo[ev.buf].shiftwidth = 4
      key('<space>gb', '<cmd>GoBuild<cr>', 'Go: build module', ev.buf)
      key('<space>gr', '<cmd>GoRun<cr>', 'Go: run package', ev.buf)
      key('<space>gv', '<cmd>GoVet<cr>', 'Go: vet module', ev.buf)
      key('<space>gc', '<cmd>GoCoverage<cr>', 'Go: coverage', ev.buf)
      key('<space>tn', function() vim.cmd.update(); neotest.run.run() end, 'Test: nearest', ev.buf)
      key('<space>tf', function()
        vim.cmd.update()
        neotest.run.run(vim.fn.expand('%:p'))
      end, 'Test: file', ev.buf)
      key('<space>ts', function()
        vim.cmd.update()
        neotest.run.run(module_root())
      end, 'Test: module', ev.buf)
      key('<space>tl', neotest.run.run_last, 'Test: repeat last', ev.buf)
      key('<space>to', function() neotest.output.open({ enter = true }) end, 'Test: output', ev.buf)
      key('<space>tt', neotest.summary.toggle, 'Test: toggle summary', ev.buf)
      key('<space>tx', neotest.run.stop, 'Test: stop', ev.buf)
      key('<space>dt', function()
        vim.cmd.update()
        require('dap-go').debug_test()
      end, 'Go: debug nearest test', ev.buf)
    end,
  })
end

return M
