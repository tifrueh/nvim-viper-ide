local state = require("viper-ide.state")

local M = {}

local function start()
    state.viperserver_obj = vim.system(
        {
            'viperserver',
            '--serverMode', 'LSP',
            '--singleClient', '--port', tostring(state.viperserver_port)
        },
        { text = true },
        function () state.viperserver_state = state.se.STOPPED end
    )
    state.viperserver = state.se.STARTING
    vim.defer_fn(function ()
        if state.viperserver == state.se.STARTING then
            state.viperserver_state = state.se.RUNNING
        end
    end,
    1000
    )
end

M.ensure_started = function ()
    if state.viperserver_state == state.se.NOT_STARTED then
        start()
        vim.wait(1000)
    elseif state.viperserver_state == state.se.STARTING then
        vim.wait(1000)
    elseif state.viperserver_state == state.se.STOPPED then
        vim.notify("[LspViper] ViperServer has stopped, trying to restart …")
        start()
    end
end

M.stop = function ()
        state.viperserver_obj:kill("sigkill")
end

return M
