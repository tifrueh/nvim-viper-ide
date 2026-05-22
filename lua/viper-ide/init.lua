local state = require("viper-ide.state")
local server = require("viper-ide.server")

local M = {}

M.setup = function ()
    local augroup = vim.api.nvim_create_augroup("ViperIDE", { clear = true })

    vim.api.nvim_create_autocmd(
        "VimLeavePre",
        {
            group    = augroup,
            callback = server.stop,
        }
    )

    state.init()
end

return M
