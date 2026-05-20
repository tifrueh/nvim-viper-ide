return {
    cmd = function (dispatchers, config)
        math.randomseed(os.time())
        local port = math.random(1100,65535)
        vim.fn.jobstart("viperserver --serverMode LSP --singleClient --port " .. port )
        vim.cmd.sleep(1)
        return vim.lsp.rpc.connect('127.0.0.1', port)(dispatchers, config)
    end,
    filetypes = { 'viper' },
    root_markers = { '.git' },
    on_attach = function ()
        vim.lsp.buf.document_highlight()
    end,
    settings = {},
}
