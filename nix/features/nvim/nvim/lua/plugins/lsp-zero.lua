local lsp = require('lsp-zero').preset('recommended')
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
end)

-- When you don't have mason.nvim installed
-- You'll need to list the servers installed in your system
lsp.setup_servers({
    'omnisharp',
    'rust-analyzer',
})

lsp.setup()