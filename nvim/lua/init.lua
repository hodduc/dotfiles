local lsp_zero = require('lsp-zero')

-- TODO: https://lsp-zero.netlify.app/v3.x/blog/you-might-not-need-lsp-zero.html
--
lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('lspconfig').gopls.setup{}
