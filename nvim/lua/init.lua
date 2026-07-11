local function global_gopls()
  -- latest version of Go should be pre-installed by `mise use -g golang@..`
  local root = vim.fn.trim(vim.fn.system('cd ~ && mise where go'))
  local bin = root .. '/bin/gopls'
  if vim.v.shell_error == 0 and root ~= '' and vim.fn.executable(bin) == 1 then
    return bin
  end
  return 'gopls' -- fallback
end

vim.lsp.enable('gopls', {
  -- use fixed gopls ($GOROOT/bin/gopls) instead of following $PATH
  cmd = { global_gopls() },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local buf = args.buf
    -- override goto-local-declaration with LSP-powered goto-definition.
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf })
  end,
})
