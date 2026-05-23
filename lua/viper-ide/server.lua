local state = require("viper-ide.state")
local logger = require("viper-ide.logger")

local M = {}

local function start()
    state.viperserver_obj = vim.system(
        {
            'viperserver',
            '--serverMode', 'LSP',
            '--singleClient', '--port', tostring(state.viperserver_port)
        },
        { text = true },
        function ()
            state.viperserver_state = state.se.STOPPED
            logger.warn("ViperServer exited …")
        end
    )
    state.viperserver = state.se.STARTING
    logger.info("ViperServer starting …")
    vim.defer_fn(function ()
        if state.viperserver == state.se.STARTING then
            logger.info("ViperServer started", true)
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
        logger.warn("ViperServer has exited, trying to restart …")
        start()
    end
end

M.stop = function ()
    state.viperserver_obj:kill("sigkill")
    logger.info("ViperServer stopped")
end

return M
