require("viper-ide").setup()
local state = require("viper-ide.state")
return function (dispatchers, config)
    require("viper-ide.server").ensure_started()
    return vim.lsp.rpc.connect('127.0.0.1', state.viperserver_port)(dispatchers, config)
end
