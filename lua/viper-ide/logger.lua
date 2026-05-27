local M = {}

M.ps = {
    SUCCESS = "success",
    RUNNING = "running",
    FAILED = "failed",
    CANCEL = "cancel"
}

local current_level = vim.lsp.log.get_level()
local level_str = {
    [vim.log.levels.TRACE] = "TRACE",
    [vim.log.levels.DEBUG] = "DEBUG",
    [vim.log.levels.INFO]  = "INFO",
    [vim.log.levels.WARN]  = "WARN",
    [vim.log.levels.ERROR] = "ERROR",
}
local level_buffer = {
    [vim.log.levels.TRACE] = {},
    [vim.log.levels.DEBUG] = {},
    [vim.log.levels.INFO] = {},
    [vim.log.levels.WARN] = {},
    [vim.log.levels.ERROR] = {},
}


local function format(msg, level_str)
    return "[ViperIDE][" .. level_str .. "] " .. msg
end

local function flush(level)
    for _,b in ipairs(level_buffer[level]) do
        vim.notify(b, level)
    end
    level_buffer[level] = {}
end

local function create_writer(level)
    return function (msg)
        if current_level <= level then
            table.insert(level_buffer[level], format(msg, level_str[level]))
            vim.schedule(function () flush(level) end)
        end
    end
end

M.trace = create_writer(vim.log.levels.TRACE)
M.debug = create_writer(vim.log.levels.DEBUG)
M.info = create_writer(vim.log.levels.INFO)
M.warn = create_writer(vim.log.levels.WARN)
M.error = create_writer(vim.log.levels.ERROR)

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

M.get_level = function ()
    return current_level
end

M.set_level = function (level)
    vim.lsp.log.set_level(level)
    current_level = level
end

return M
