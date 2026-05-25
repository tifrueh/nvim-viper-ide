return {
    cmd = require('viper-ide.cmd'),
    capabilities = require('viper-ide.capabilities'),
    filetypes = { 'viper' },
    root_markers = { '.git' },
    on_attach = function ()
        vim.lsp.buf.document_highlight()
    end,
    handlers = require('viper-ide.handlers'),
    settings = {},
}
