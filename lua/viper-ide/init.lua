local M = {}

M.state = require("viper-ide.state")
M.server = require("viper-ide.server")
M.logger = require("viper-ide.logger")

M.setup = function ()
    local augroup = vim.api.nvim_create_augroup("ViperIDE", { clear = true })

    vim.api.nvim_create_autocmd(
        "VimLeavePre",
        {
            group    = augroup,
            callback = M.server.stop,
        }
    )

    M.state.init()
    M.logger.current_level = vim.log.levels.DEBUG
    M.logger.info("ViperIDE initialised")
end

viper_ide = M

return M
