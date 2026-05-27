local M = {}

-- (Re-)Set settings based on a client config.
local function set_settings (config)
    if config.settings.viper_file_endings then
        M.viper_file_endings = config.settings.viper_file_endings
    end
    if config.settings.verification_backend then
        M.verification_backend = config.settings.verification_backend
    end
    if config.settings.server_exec then
        M.viperserver_exec = config.settings.server_exec
    end
    if config.settings.server_port then
        if config.settings.server_port >= 0 then
            M.viperserver_port = config.settings.server_port
        end
    end
    if config.settings.server_extra_args then
        M.viperserver_extra_args = config.settings.server_extra_args
    end
    if config.settings.java_tool_options then
        M.java_tool_options = config.settings.java_tool_options
    end
end

M.init = function ()
    -- The server executable.
    M.viperserver_exec = "viperserver"
    -- Extra arguments for the server.
    M.viperserver_extra_args = {}
    -- The port to run the server on.
    math.randomseed(os.time())
    M.viperserver_port = math.random(1100,65535)
    -- "Enum" for executable states.
    M.se = { NOT_STARTED = "0", STARTING = "1", RUNNING = "2", STOPPED = "3" }
    -- The state of the ViperServer executable as one of the states above.
    M.viperserver_state = M.se.NOT_STARTED
    -- The SystemObj of the ViperServer itself. Is nil before the server is first started.
    M.viperserver_obj = nil
    -- The list of file endings that are to be taken as viper files.
    M.viper_file_endings = { ".vpr", ".sil" }
    -- The project root URI (will be set by ViperServer on initialisation).
    M.project_uri = ""
    -- Other URIs (will be set by ViperServer on initialisation). Not sure what
    -- this does, though.
    M.other_uris = ""
    -- The verification backend to use.
    M.verification_backend = "silicon"
    -- The contents used for the JAVA_TOOL_OPTION environment variable.
    M.java_tool_options = nil

    -- Use the settings table of the LSP config to (re-)set settings.
    local config = vim.lsp.get_configs({ filetype = "viper" })[1]
    set_settings(config)
end

return M
