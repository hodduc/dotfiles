vim.lsp.enable('gopls')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local buf = args.buf
    -- override goto-local-declaration with LSP-powered goto-definition.
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf })
  end,
})
