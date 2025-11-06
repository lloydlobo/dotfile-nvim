local M = {}

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local map = vim.keymap.set

local supported = {
    bash = {
        patterns = { "%.sh$", "%.bash$", "%.zsh$" },
        cmd = "shfmt -w",
    },
    fsharp = {
        patterns = { "%.fs$", "%.fsx$", "%.fsi$" },
        cmd = "fantomas",
    },
    markdown = {
        patterns = { "%.md$" },
        cmd = "prettier --write",
    },
    lua = {
        patterns = { "%.lua$" },
        cmd = "stylua",
    },
}

local function schedule_notify(msg, level, opts)
    vim.schedule(function() vim.notify(msg, level or vim.log.levels.DEBUG, opts or {}) end)
end

-- FIXME: MAYBE: Only uses filename patterns. If a buffer is unsaved or has no extension, it will fail.
local function detect_filetype(bufname) -- : Result<bool, string>
    for filetype, info in pairs(supported) do
        for _, pattern in ipairs(info.patterns) do
            if bufname:match(pattern) then return true, filetype end
        end
    end
    return false, nil
end

local function is_formatter_installed(cmd)
    local handle = io.popen("which " .. cmd)
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

local function format_buffer(bufnr)
    bufnr = bufnr or api.nvim_get_current_buf() -- default to current buffer
    local bufname = api.nvim_buf_get_name(bufnr)

    if bufname == "" then
        schedule_notify("Cannot format an unsaved buffer. Please save it first.", vim.log.levels.WARN)
        return
    end

    local matched, filetype = detect_filetype(bufname) -- 0: current buffer
    if not matched then
        schedule_notify("Current buffer does NOT match supported patterns", vim.log.levels.WARN)
        return
    end

    if false then
        -- NOTE: safer fallback to buffer-local filetype
        -- FIXME: instead of assigning, parse check and bail fi fieltype doesn't match
        -- WHY DON"T WE JUST WARN THE USER< OF THIS CASE!!!!!! ---->> Now, if the file matches a pattern but the filetype is missing, it will safely get the buffer-local filetype.
        filetype = filetype or api.nvim_buf_get_option(bufnr, "filetype") or vim.bo.filetype -- is this a code smell?
    end

    local info = supported[filetype] -- local format_cmd = formatters[filetype]
    if not info or not info.cmd then
        schedule_notify("No formatter configured for filetype: " .. tostring(filetype), vim.log.levels.WARN)
        return
    end

    -- Check if the formatter is installed
    if not is_formatter_installed(info.cmd) then
        schedule_notify("Formatter for " .. filetype .. " is not installed: " .. info.cmd, vim.log.levels.ERROR)
        return
    end

    local system_cmd = info.cmd .. " " .. vim.fn.shellescape(bufname)

    schedule_notify("Running: " .. filetype .. " formatter: " .. system_cmd, vim.log.levels.INFO)

    cmd("write") -- #1 save buffer before formatting
    fn.system(system_cmd) -- #2 synchronous formatting (see also: uv.spawn)
    cmd("edit") -- #3 restore cursor/viewport

    schedule_notify("Formatted successfully: " .. bufname, vim.log.levels.INFO)
end

-- Ctrl-F formats a file based of extension
-- NOTE: Using { buffer = 0 } maps it per-buffer, only for the current buffer where setup() is called.
--       If you want a global keymap for any buffer, remove buffer = 0.
function M.setup()
    map("n", "<leader>f", function() format_buffer() end, { buffer = 0, desc = "Format this buffer" })
end

return M

-- TODO: Steal pretty logger formatting / style from the native stack traceback:
--
-- E5108: Lua: /home/user/.config/nvim/lua/custom/format.lua:56: attempt to index global 'formatters' (a nil value)
-- stack traceback:
--         /home/user/.config/nvim/lua/custom/format.lua:56: in function </home/user/.config/nvim/lua/custom/format.lua:42>
-- Press ENTER or type command to continue
