local M = {}

M.state = require("viper-ide.state")
M.server = require("viper-ide.server")
M.logger = require("viper-ide.logger")
M.commands = require("viper-ide.commands")

M.setup = function ()

    M.logger.trace("Registering autocommand group …")
    local augroup = vim.api.nvim_create_augroup("ViperIDE", { clear = true })

    M.logger.trace("Registering autocommands …")
    vim.api.nvim_create_autocmd(
        "VimLeavePre",
        {
            group    = augroup,
            callback = M.server.stop,
        }
    )

    M.logger.trace("Initialising state …")
    M.state.init()

    M.logger.trace("Registering commands …")
    vim.api.nvim_create_user_command(
        "LspViperVerify",
        function () M.commands.user_command_verify() end,
        {
            desc = "Run verification on the current buffer."
        }
    )
    vim.api.nvim_create_user_command(
        "LspViperStop",
        function () M.commands.user_command_stop_verification() end,
        {
            desc = "Stop the verification of the current buffer."
        }
    )

    M.logger.debug("ViperIDE initialised")
end

viper_ide = M

return M
