local M = {}

local logger = require("viper-ide.logger")
local state = require("viper-ide.state")
local handlers = require("viper-ide.handlers")

local run_verify = function (manually_triggered)
    local client = vim.lsp.get_clients({ bufnr = 0, name = "viperserver" })[1]
    if not client then
        logger.error("Coult not find LSP client for verification. Is it running?")
        return
    end
    client:notify(
        "Verify",
        {
            uri = vim.uri_from_bufnr(0),
            content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"),
            manuallyTriggered = manually_triggered,
            workspace = state.root_uri,
            backend = state.verification_backend,
            customArgs = ""
        }
    )
end

local stop_verification = function ()
    local client = vim.lsp.get_clients({ bufnr = 0, name = "viperserver" })[1]
    if not client then
        logger.error("Coult not find LSP client for stopping verification. Is it running?")
        return
    end
    client:request(
        "StopVerification",
        {
            uri = vim.uri_from_bufnr(0)
        },
        handlers["StopVerification"]
    )
end

M.user_command_verify = function (args)
    run_verify(true)
end

M.user_command_stop_verification = function (args)
    stop_verification()
end

return M
