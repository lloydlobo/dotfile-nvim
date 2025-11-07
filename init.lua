local opt = vim.opt
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "
opt.swapfile, opt.undofile = false, true
opt.clipboard = "unnamedplus"
opt.ignorecase, opt.smartcase = true, false
opt.laststatus = 0
opt.showcmd, opt.showmode = false, false
opt.wrap, opt.breakindent, opt.showbreak = false, true, "↪ "
opt.list, opt.listchars = true, { tab = "┊ " or "| ", trail = "·", nbsp = "␣" }
opt.signcolumn = "auto:4-8" -- always show, exactly 4 columns (or yes:4) (max 9)
opt.expandtab, opt.tabstop, opt.shiftwidth = true, 4, 4
opt.softtabstop = -1 -- use shiftwidth value
opt.scrolloff = 10
opt.inccommand = "split"
opt.splitright, opt.splitbelow = true, true
opt.ruler, opt.cursorline, opt.termguicolors = true, true, true -- (optional) -- explicit defaults kept for clarity
cmd.syntax("on") -- (optional) -- on|off|enable # :source $VIMRUNTIME/syntax/syntax.vim
cmd.colorscheme("brightburn_v2") -- builtins: default|lunaperche|quiet|retrobox|unokai|wildcharm|zaibatsu -- custom: brightburn|brightburn_v1|brightburn_v2
for _, name in ipairs({ "Normal", "NormalFloat", "SignColumn" }) do
    api.nvim_set_hl(0, name, { bg = "NONE", fg = "NONE" }) -- bg: NONE|#111111|#282828 fg: NONE|#5fd7ff|#82def7|#d78700|#5787af|#b5d1b5|#9ec49e|#b9d4b9|#b9d2d4
end
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
map("n", "<leader>d", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>m", "<cmd>marks<CR>", { desc = "List all marks/bookmarks" })
map("n", "<leader>M", "<cmd>delmarks!<CR>", { desc = "Delete all lowercase marks/bookmarks" })
map("n", "<leader>y", function() fn.setreg("+", fn.expand("%:p")) end, { desc = "Yank file path to clipboard" })
map("n", "<leader>c", function()
    vim.ui.input({ prompt = "$ " }, function(input) -- alternativelly, use `:vnew | read !cmd`
        if not input or input == "" then return end
        cmd("noswapfile vnew | setlocal buftype=nofile bufhidden=wipe filetype=sh scrolloff=0 nowrap")
        cmd("file [Scratch: " .. fn.escape(input, " ") .. " @ " .. os.date("%Y%m%dT%H%M%S") .. "]") -- escape command for use in filename
        api.nvim_buf_set_lines(0, 0, -1, false, fn.systemlist(input))
    end)
end, { desc = "Run command in scratch buffer" })
api.nvim_create_autocmd("TextYankPost", {
    group = api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})
api.nvim_create_autocmd("BufRead", {
    group = api.nvim_create_augroup("FSharpMessageGroup", { clear = true }),
    pattern = { "*.fs", "*.fsx", "*.fsscript" },
    callback = function() cmd("setlocal filetype=fsharp syntax=gleam commentstring=//\\ %s") end,
})
require("custom.format").setup()
-- see `:h modeline`
-- vim:filetype=lua:
-- vim:tw=78:ts=4:sw=4:et:ft=help:norl:
