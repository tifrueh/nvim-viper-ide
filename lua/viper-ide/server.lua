local state = require("viper-ide.state")
local logger = require("viper-ide.logger")

local M = {}

local stdout_buf = ""
local stderr_buf = ""

local function start()
    local server_command = {
        state.viperserver_exec,
        '--serverMode', 'LSP',
        '--singleClient', '--port', tostring(state.viperserver_port)
    }
    for _,val in ipairs(state.viperserver_extra_args) do
        table.insert(server_command, val)
    end
    state.viperserver_obj = vim.system(
        server_command,
        {
            text = true,
            stdout = function (err, data)
                if err then return end
                if data then
                    logger.debug(data)
                end
            end,
            stderr = function (err, data)
                if err then return end
                if data then
                    logger.warn(data)
                end
            end,
            env = {
                ["JAVA_TOOL_OPTIONS"] = state.java_tool_options
            }
        },
        function ()
            state.viperserver_state = state.se.STOPPED
            logger.warn("ViperServer exited …")
        end
    )
    state.viperserver = state.se.STARTING
    logger.trace("ViperServer starting …")
    vim.defer_fn(function ()
        if state.viperserver == state.se.STARTING then
            logger.trace("ViperServer started", true)
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
    logger.trace("ViperServer stopped")
end

return M
