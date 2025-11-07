--- File formatting based on file extensions, triggered by keymap `Ctrl-F`.
local M = {}
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local map = vim.keymap.set
local log = vim.log.levels
local loop = vim.loop -- used for modern job control (vim.uv)
local function format_buffer(opts)
    local default_opts = {
        write_before_format = false,
        reload_after_format = true, -- reload file and restore cursor/viewport
    }
    local supported = {
        bash = { patterns = { "%.sh$", "%.bash$", "%.zsh$" }, cmd = "npx shfmt -w" },
        fsharp = { patterns = { "%.fs$", "%.fsx$", "%.fsi$" }, cmd = "fantomas" },
        lua = { patterns = { "%.lua$" }, cmd = "stylua" },
        markdown = { patterns = { "%.md$" }, cmd = "npx prettier --write" },
        python = { patterns = { "%.py$" }, cmd = "uvx ruff format" },
    }

    local function notify(msg, level)
        vim.schedule(function() vim.notify(msg, level or log.INFO, { title = "Formatter" }) end)
    end
    local function is_installed(cmd) -- only check the first word (the executable)
        local exe = cmd:match("^%S+")
        return #vim.fn.system("which " .. exe) > 1 -- (system() includes the trailing newline, hence '> 1')
    end -- local function is_installed(cmd) return #fn.system("which " .. cmd) > 1 end
    local function detect_filetype(bufname) -- only uses filename patterns. If a buffer is unsaved or has no extension, it will fail.
        for filetype, info in pairs(supported) do -- bypass Neovim's internal filetype detection (e.g., modelines).
            for _, pattern in ipairs(info.patterns) do
                if bufname:match(pattern) then return true, filetype end
            end -- see also `api.nvim_buf_get_option(bufnr, "filetype") or vim.bo.filetype`
        end
        return false, nil -- : Result<bool, string option>
    end

    opts = vim.tbl_extend("force", default_opts, opts or {})

    local bufnr = api.nvim_get_current_buf()
    local bufname = api.nvim_buf_get_name(bufnr)
    if bufname == "" then return notify("Unsaved buffer, save first.", log.WARN) end

    local nvim_filetype = api.nvim_buf_get_option(bufnr, "filetype") -- TODO: Use this when file has no extension. For example, a bash file with shebang may have filetype set to `sh`
    if not nvim_filetype or nvim_filetype == "" then return notify("Could not detect Neovim filetype.", log.WARN) end

    local matched, ext_filetype = detect_filetype(bufname)
    if not matched then return notify("Current buffer (file extension) does NOT match supported patterns", log.WARN) end

    local info = supported[ext_filetype]
    if not info then return notify("No formatter for: " .. ext_filetype, log.WARN) end
    if not is_installed(info.cmd) then return notify("Formatter missing: " .. info.cmd, log.ERROR) end

    if ext_filetype ~= nvim_filetype then -- ext_filetype mismatch! { matched=true nvim_filetype=zsh filetype=bash }                                                                      1,1           Top
        local fmt = "Filetype mismatch: extension '%s', Neovim '%s'. Formatting anyway."
        notify(string.format(fmt, ext_filetype, nvim_filetype), log.WARN)
    end

    local async_format = function() -- prevents blocking of buffer for large files.. (happily move around while it's formatting)
        local args = { bufname }
        local job = fn.jobstart(info.cmd .. " " .. fn.shellescape(bufname), {
            stdout_buffered = true, -- collect data until EOF (stream closed) before invoking `on_stdout`
            stderr_buffered = true, -- collect data until EOF (stream closed) before invoking `on_stderr`
            on_exit = function(_, code)
                if code ~= 0 then return notify("Formatting failed (Code " .. code .. "): " .. bufname, log.ERROR) end
                notify("Formatted successfully: " .. bufname)
                if opts.reload_after_format then cmd("edit") end
            end,
            on_stderr = function(_, data)
                if data and #data > 0 then
                    local clean = vim.tbl_filter(function(line) return line ~= "" end, data) -- strip empty lines automatically
                    if #clean > 0 then notify("Error from formatter: " .. table.concat(data, "\n"), log.ERROR) end
                end
            end,
            on_stdout = function(_, data) end, -- ignore stdout for formatters that write directly to the file
        })
        notify("Started formatting job: " .. tostring(job), log.DEBUG)
    end -- jobstart: easier to set up callbacks. (or vim.loop/vim.uv for more modern approach).

    if opts.write_before_format then cmd("write") end -- save buffer before formatting
    async_format() -- see also: fn.has("job") == 1
end
function M.setup()
    local opts = { write_before_format = true } -- NOTE: Using { buffer = 0 } maps it per-buffer, only for the current buffer where setup() is called.
    map("n", "<leader>f", function() format_buffer(opts) end, { desc = "Format this buffer", noremap = true }) -- If you want a global keymap for any buffer, remove buffer = 0.

    local enabled_auto_format_on_save = true -- FIXME: This leads to double saves..
    if enabled_auto_format_on_save then -- 1. save event via user
        api.nvim_create_autocmd({ "BufWritePre" }, { -- 2. save event just before format event in format_buffer()
            group = api.nvim_create_augroup("AutoFormatOnSave", { clear = true }), -- clear old ones safely
            pattern = "*" or { "*" }, -- or a list of filetypes, e.g., { "*.lua", "*.py" }
            callback = function() format_buffer({ write_before_format = false }) end, -- callback = format_buffer,
            desc = "Auto-format on save",
        })
    end
end
return M
--
-- ---  ---
--
-- local M = {}
-- local config = require("tinyform.config")
-- -- Run formatter(s) for current buffer
-- function M.format(opts)
--   opts = opts or {}
--   local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
--   local ft = vim.bo[bufnr].filetype
--   local formatters = config.formatters_by_ft[ft]
--   if not formatters or #formatters == 0 then return vim.notify("No formatter for filetype: " .. ft, vim.log.levels.WARN) end
--   local filepath = vim.api.nvim_buf_get_name(bufnr)
--   vim.api.nvim_command("write")
--   local cmd = formatters[1]
--   local job = vim.fn.jobstart({ cmd, filepath }, {
--     stdout_buffered = true,
--     stderr_buffered = true,
--     on_stdout = function(_, data) if not data then return end; vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data); end,
--     on_stderr = function(_, err) if err and #err > 0 then vim.notify("Formatter error: " .. table.concat(err, "\n"), vim.log.levels.ERROR) end end,
--     on_exit = function(_, code) if code == 0 then vim.notify("Formatted with " .. cmd); else vim.notify("Formatter failed: " .. cmd, vim.log.levels.ERROR); end; end,
--   })
-- end
-- return M
--
-- ---  ---
--
-- local M, api, cmd, fn, log = {}, vim.api, vim.cmd, vim.fn, vim.log.levels; local S = { lua = { p = { "%.lua$" }, c = "stylua" }, md = { p = { "%.md$" }, c = "npx prettier --write" } }
-- local function n(m, l) vim.schedule(function() vim.notify(m, l or log.DEBUG, {}) end) end
-- local function f() local B, N = api.nvim_get_current_buf(), api.nvim_buf_get_name; if N(B) == "" then return n("Unsaved.", log.WARN) end; local F; for k, v in pairs(S) do if N(B):match(v.p[1]) then F = v break end end; if not F then return n("No format.", log.WARN) end; if #fn.system("which " .. F.c:match("^%S+")) <= 1 then return n("Missing: "..F.c, log.ERROR) end; cmd("write"); fn.jobstart(F.c.." "..fn.shellescape(N(B)), { on_exit = function(_, c) if c ~= 0 then return n("Failed.", log.ERROR) end; n("OK", log.INFO); cmd("edit") end, on_stderr = function(_, d) n("Error: "..table.concat(d), log.ERROR) end }) end
-- function M.setup() vim.keymap.set("n", "<leader>f", f, { desc = "Format", silent = true, noremap = true }) end
-- return M
--
-- ---  ---
--
-- -- File formatter based on file extension
-- local M, api, cmd, fn, log = {}, vim.api, vim.cmd, vim.fn, vim.log.levels
--
-- local formatters = {
--     bash = { "%.sh$", "%.bash$", "%.zsh$", cmd = "npx shfmt -w" },
--     fsharp = { "%.fs$", "%.fsx$", "%.fsi$", cmd = "fantomas" },
--     lua = { "%.lua$", cmd = "stylua" },
--     markdown = { "%.md$", cmd = "npx prettier --write" },
--     python = { "%.py$", cmd = "uvx ruff format" },
-- }
-- local function notify(msg, level)
--     vim.schedule(function() vim.notify(msg, level or log.INFO, { title = "Formatter" }) end)
-- end
-- local function is_installed(cmd)
--     return #fn.system("which " .. cmd:match("^%S+")) > 1
-- end
-- local function detect_formatter(name)
--     for ft, info in pairs(formatters) do
--         for _, pat in ipairs(info) do
--             if type(pat) == "string" and name:match(pat) then return ft, info.cmd end
--         end
--     end
-- end
-- local function format_buffer(opts)
--     opts = vim.tbl_extend("force", { write_before_format = false, reload_after_format = true }, opts or {})
--     local bufnr = api.nvim_get_current_buf()
--     local name = api.nvim_buf_get_name(bufnr)
--     if name == "" then return notify("Unsaved buffer", log.WARN) end
--
--     local ft, cmd_str = detect_formatter(name)
--     if not ft then return notify("No formatter for this file", log.WARN) end
--     if not is_installed(cmd_str) then return notify("Formatter missing: " .. cmd_str, log.ERROR) end
--
--     if opts.write_before_format then cmd("write") end
--     fn.jobstart(cmd_str .. " " .. fn.shellescape(name), {
--         stdout_buffered = true, stderr_buffered = true,
--         on_exit = function(_, code)
--             if code ~= 0 then return notify("Formatting failed: " .. name, log.ERROR) end
--             notify("Formatted: " .. name)
--             if opts.reload_after_format then cmd("edit") end
--         end,
--         on_stderr = function(_, data)
--             if data and #data > 0 then notify("Formatter error: " .. table.concat(data, "\n"), log.ERROR) end
--         end
--     })
-- end
-- function M.setup()
--     vim.keymap.set("n", "<leader>f", function() format_buffer({ write_before_format = true }) end, { desc = "Format buffer" })
--     vim.api.nvim_create_autocmd("BufWritePre", {
--         group = api.nvim_create_augroup("AutoFormatOnSave", { clear = true }),
--         pattern = "*",
--         callback = function() format_buffer({ write_before_format = false }) end,
--     })
-- end
-- return M
