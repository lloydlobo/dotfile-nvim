local M = {} --- File formatting based on file extensions, triggered by keymap `Ctrl-F`.
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local map = vim.keymap.set
local log = vim.log.levels
local loop = vim.loop -- used for modern job control (vim.uv)
local function format_buffer(opts)
    local default_opts = { write_before_format = false, reload_after_format = true }
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
                if opts.reload_after_format then cmd("edit") end -- reload file and restore cursor/viewport
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
    local enabled_auto_format_on_save = false -- FIXME: This leads to double saves..
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
