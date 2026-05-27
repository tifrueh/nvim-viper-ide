local M = {}

M.current_level = vim.log.levels.WARN
M.ps = {
    SUCCESS = "success",
    RUNNING = "running",
    FAILED = "failed",
    CANCEL = "cancel"
}

local function format(msg, level_str)
    return "[ViperIDE][" .. level_str .. "] " .. msg
end

M.trace = function (msg)
    if M.current_level <= vim.log.levels.TRACE then
        vim.notify(format(msg, "TRACE"), vim.log.levels.TRACE)
    end
end

M.debug = function (msg)
    if M.current_level <= vim.log.levels.DEBUG then
        vim.notify(format(msg, "DEBUG"), vim.log.levels.DEBUG)
    end
end

M.info = function (msg)
    if M.current_level <= vim.log.levels.INFO then
        vim.notify(format(msg, "INFO"), vim.log.levels.INFO)
    end
end

M.warn = function (msg)
    if M.current_level <= vim.log.levels.WARN then
        vim.notify(format(msg, "WARN"), vim.log.levels.WARN)
    end
end

M.error = function (msg)
    if M.current_level <= vim.log.levels.ERROR then
        vim.notify(format(msg, "ERROR"), vim.log.levels.ERROR)
    end
end

M.progress = function (msg, percent, status)
    vim.api.nvim_echo(
        {{ msg }},
        true,
        {
            kind = "progress",
            percent = percent,
            source = "ViperIDE",
            status = status
        }
    )
end

return M
