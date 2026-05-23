local M = {}

M.init = function ()
    math.randomseed(os.time())
    -- The port to run ViperServer on.
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
end

return M
