logger = require("viper-ide.logger")
state = require("viper-ide.state")

-- CLIENT TO SERVER RESPONSE HANDLERS ==========================================

---@type vim.lsp.ResponseHandler
local function handle_getversion_response(err, result, ctx)
    if err then
        logger.warn("Got GetVersion error: " .. err.message)
        return
    end
    logger.info("Got GetVersion response: " .. result.serverVersion)
end

---@type vim.lsp.ResponseHandler
local function handle_stopverification_response(err, result, ctx)
    if err then
        logger.warn("Got StopVerification error: " .. err.message)
        return
    end
    if result.success then
        logger.info("Verification stopped")
    else
        logger.warn("Couldn't stop verification …")
    end
end

---@type vim.lsp.ResponseHandler
local function handle_getlanguageserverurl_response(err, result, ctx)
    if err then
        logger.warn("Got GetLanguageServerUrl error: " .. err.message)
        return
    end
    logger.info("Language server URL: " .. response.url)
end

---@type vim.lsp.ResponseHandler
local function handle_removediagnostics_response(err, result, ctx)
    if err then
        logger.warn("Got RemoveDiagnostics error: " .. err.message)
        return
    end
    if result.success then
        logger.info("Removed diagnostics")
    else
        logger.warn("Couldn't remove diagnostics …")
    end
end

---@type vim.lsp.ResponseHandler
local function handle_flushcache_response(err, result, ctx)
    -- I don't think that this response contains anyting / is implemented. So
    -- it doesn't make a lot of sense to do anything here.
    return
end


-- SERVER TO CLIENT NOTIFICATION HANDLERS ======================================

---@type vim.lsp.NotificationHandler
local function handle_statechange_notification(err, result, ctx)
    if err then
        logger.warn("Got StateChange error: " .. err.message)
        return
    end
    logger.info("Got StateChange: " .. vim.print(result))
    -- TODO Implement the whole local state thing.
end

---@type vim.lsp.NotificationHandler
local function handle_log_notification(err, result, ctx)
    if err then
        logger.warn("Got Log error: " .. err.message)
        return
    end
    logger.info("[ViperServer][" .. result.logLevel .."] " .. result.data)
end

---@type vim.lsp.NotificationHandler
local function handle_hint_notification(err, result, ctx)
    if err then
        logger.warn("Got Hint error: " .. err.message)
        return
    end
    vim.info("Hint: " .. result.message)
end

---@type vim.lsp.NotificationHandler
local function handle_verificationnotstarted_notification(err, result, ctx)
    if err then
        logger.warn("Got VerificationNotStarted error: " .. err.message)
        return
    end
    logger.warn("Verification of file not started: " .. result.uri)
end

---@type vim.lsp.NotificationHandler
local function handle_unhandledviperservermessage_notification(err, result, ctx)
    if err then
        logger.warn("Got UnhandledViperServerMessage error: " .. err.message)
        return
    end
    logger.warn("ViperServer reported unhandled message of type " .. result.msg.msgType .. ": " .. result.msg)
end

-- SERVER TO CLIENT REQUEST HANDLERS ===========================================

---@type vim.lsp.RequestHandlers
local function handle_getviperfileendings_request(err, result, ctx)
    return { fileEndings = state.viper_file_endings }
end

---@type vim.lsp.RequestHandlers
local function handle_setupproject_request(err, result, ctx)
    state.project_uri = result.projectUri
    state.other_uris = result.otherUris
    return {}
end

---@type vim.lspRequestHandlers
local function handle_getidentifier_request(err, result, ctx)
    -- Doesn't do anything for now.
    return { identifier = "" }
end

---@type vim.lspRequestHandlers
local function handle_getrange_request(err, result, ctx)
    -- Doesn't do anything for now.
    return { range = "" }
end

-- COMPOSITION FUNCTION ========================================================

return {
    ["GetVersion"]                  = handle_getversion_response,
    ["StopVerification"]            = handle_stopverification_response,
    ["GetLanguageServerUrl"]        = handle_getlanguageserverurl_response,
    ["RemoveDiagnostics"]           = handle_removediagnostics_response,
    ["FlushCache"]                  = handle_flushcache_response,
    ["StateChange"]                 = handle_statechange_notification,
    ["Log"]                         = handle_log_notification,
    ["Hint"]                        = handle_hint_notification,
    ["VerificationNotStarted"]      = handle_verificationnotstarted_notification,
    ["UnhandledViperServerMessage"] = handle_unhandledviperservermessage_notification,
    ["GetViperFileEndings"]         = handle_getviperfileendings_request,
    ["SetupProject"]                = handle_setupproject_request,
    ["GetIdentifier"]               = handle_getidentifier_request,
    ["GetRange"]                    = handle_getrange_request
}
