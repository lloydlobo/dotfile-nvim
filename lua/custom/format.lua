--- Ctrl-F formats a file based on extension.
--- FIXME: This fails when file is big/npx has to download/cache formatter
local M = {}

local api, cmd, fn, map = vim.api, vim.cmd, vim.fn, vim.keymap.set

local supported = {
    bash = { patterns = { "%.sh$", "%.bash$", "%.zsh$" }, cmd = "npx shfmt -w" },
    fsharp = { patterns = { "%.fs$", "%.fsx$", "%.fsi$" }, cmd = "fantomas" },
    markdown = { patterns = { "%.md$" }, cmd = "npx prettier --write" },
    lua = { patterns = { "%.lua$" }, cmd = "stylua" },
}

local function notify(msg, level, opts)
    vim.schedule(function() vim.notify(msg, level or vim.log.levels.DEBUG, opts or {}) end)
end

-- NOTE: Only uses filename patterns. If a buffer is unsaved or has no extension, it will fail.
local function detect_filetype(bufname) -- : Result<bool, string>
    for filetype, info in pairs(supported) do
        for _, pattern in ipairs(info.patterns) do
            if bufname:match(pattern) then return true, filetype end -- see also `api.nvim_buf_get_option(bufnr, "filetype") or vim.bo.filetype`
        end
    end
    return false, nil
end

local function is_installed(cmd) return #fn.system("which " .. cmd) > 0 end

local function format_buffer(bufnr)
    bufnr = bufnr or api.nvim_get_current_buf() -- 0: current buffer
    local bufname = api.nvim_buf_get_name(bufnr)
    if bufname == "" then return notify("Unsaved buffer, save first.", vim.log.levels.WARN) end

    local matched, filetype = detect_filetype(bufname)
    if not matched then return notify("Current buffer does NOT match supported patterns", vim.log.levels.WARN) end
    local info = supported[filetype]
    if not info then return notify("No formatter for: " .. filetype, vim.log.levels.WARN) end
    if not is_installed(info.cmd) then return notify("Formatter missing: " .. info.cmd, vim.log.levels.ERROR) end

    cmd("write") --           #1 save buffer before formatting
    fn.system(info.cmd .. " " .. vim.fn.shellescape(bufname)) --  #2 synchronous formatting (see also: uv.spawn)
    cmd("edit") --            #3 restore cursor/viewport
    notify("Formatted successfully: " .. bufname, vim.log.levels.INFO)
end

function M.setup() -- NOTE: Using { buffer = 0 } maps it per-buffer, only for the current buffer where setup() is called.
    map("n", "<leader>f", format_buffer, { buffer = 0, desc = "Format this buffer" })
end --  If you want a global keymap for any buffer, remove buffer = 0.

return M
