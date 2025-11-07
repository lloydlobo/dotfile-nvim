--- Ctrl-F formats a file based on extension.
local M = {}

local api, cmd, fn, map, levels = vim.api, vim.cmd, vim.fn, vim.keymap.set, vim.log.levels

local supported = {
    bash = { patterns = { "%.sh$", "%.bash$", "%.zsh$" }, cmd = "npx shfmt -w" },
    fsharp = { patterns = { "%.fs$", "%.fsx$", "%.fsi$" }, cmd = "fantomas" },
    markdown = { patterns = { "%.md$" }, cmd = "npx prettier --write" },
    lua = { patterns = { "%.lua$" }, cmd = "stylua" },
}

local function notify(msg, level, opts)
    vim.schedule(function() vim.notify(msg, level or levels.DEBUG, opts or {}) end)
end

local function format_buffer()
    local function is_installed(cmd) return #fn.system("which " .. cmd) > 0 end

    local function detect_filetype(bufname) -- try to detect filetype based on file extension (bypasses modelines)
        for filetype, info in pairs(supported) do
            for _, pattern in ipairs(info.patterns) do
                if bufname:match(pattern) then return true, filetype end
            end -- see also `api.nvim_buf_get_option(bufnr, "filetype") or vim.bo.filetype`
        end
        return false, nil -- : Result<bool, string option>
    end -- NOTE: Only uses filename patterns. If a buffer is unsaved or has no extension, it will fail.

    local bufnr = api.nvim_get_current_buf()
    local bufname = api.nvim_buf_get_name(bufnr)
    if bufname == "" then return notify("Unsaved buffer, save first.", levels.WARN) end

    -- TODO: Use this when file has no extension. For example, a bash file with shebang may have filetype set to `sh`
    local filetype_ = api.nvim_buf_get_option(bufnr, "filetype")
    if not filetype_ then return notify("Could not detect filetype", levels.WARN) end

    local matched, filetype = detect_filetype(bufname)
    -- TODO: Cases to handle:
    --       • [ ] Error: Filetype mismatch! { matched=true filetype_=zsh filetype=bash }                                                                      1,1           Top
    if filetype_ and filetype and filetype ~= filetype_ then
        local msg = "Error: Filetype mismatch! "
        local reason = "{ "
            .. ("matched=" .. tostring(matched))
            .. (" filetype_=" .. (filetype_ or "NIL(filetype_)"))
            .. (" filetype=" .. (filetype or "NIL(filetype)"))
            .. " }"
        notify(msg .. reason, levels.ERROR)
        return
    end
    if not matched then return notify("Current buffer does NOT match supported patterns", levels.WARN) end

    local info = supported[filetype]
    if not info then return notify("No formatter for: " .. filetype, levels.WARN) end

    if not is_installed(info.cmd) then return notify("Formatter missing: " .. info.cmd, levels.ERROR) end

    -- #1. Save buffer before formatting
    cmd("write")

    -- #2. Format buffer via system call (see also: uv.spawn)
    local is_async = true
    if is_async then
        vim.fn.jobstart(info.cmd .. " " .. vim.fn.shellescape(bufname), {
            on_exit = function(_, code)
                if code ~= 0 then return notify("Formatting failed: " .. bufname, levels.ERROR) end
                notify("Formatted successfully: " .. bufname, levels.INFO)

                -- #3. Restore cursor/viewport
                cmd("edit")
            end,
            on_stderr = function(_, data) notify("Error from formatter: " .. table.concat(data, "\n"), levels.ERROR) end,
            on_stdout = function(_, data) end, -- Optionally, you can use this to capture output from the formatter and display it in the command-line or handle it as needed. For now, let's just ignore it.
        })
    else
        fn.system(info.cmd .. " " .. fn.shellescape(bufname))
        if vim.v.shell_error ~= 0 then return notify("Formatting failed: " .. bufname, levels.ERROR) end
        notify("Formatted successfully: " .. bufname, levels.INFO)

        -- #3. Restore cursor/viewport
        cmd("edit")
    end
end

function M.setup()
    -- NOTE: Using { buffer = 0 } maps it per-buffer, only for the current buffer where setup() is called.
    --       If you want a global keymap for any buffer, remove buffer = 0.
    map("n", "<leader>f", format_buffer, {
        desc = "Format this buffer", --
        noremap = true,
        -- silent = true,
    })
end

return M
