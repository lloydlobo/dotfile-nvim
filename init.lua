local opt, map = vim.opt, vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.undofile = true
opt.clipboard = "unnamedplus"
opt.ignorecase, opt.smartcase = true, true
opt.laststatus = 0
opt.ruler, opt.showcmd, opt.showmode = false, false, false
opt.cursorline, opt.wrap, opt.breakindent = false, false, true
opt.signcolumn = "auto:4-9" -- always show, exactly 4 columns (or yes:4) (max 9)
opt.termguicolors = true
opt.expandtab = true
opt.tabstop, opt.shiftwidth = 4, 4
opt.softtabstop = -1 -- same as opt.shiftwidth:get()
opt.scrolloff = 10
opt.splitright, opt.splitbelow = true, true
opt.inccommand = "split" -- show effects of |:substitute|, |:smagic|, |:snomagic| and user commands with |:command-preview|

vim.cmd.syntax("off")
vim.cmd.colorscheme(({ "default", "retrobox", "wildcharm" })[3])
vim.api.nvim_set_hl(
    0,
    "Normal",
    ({
        { bg = "#111111", fg = "#5fd7ff" }, --[[VT100 soft cyan]]
        { bg = "NONE", fg = "#82def7" }, --[[VT100 default cyan]]
        { bg = "#282828", fg = "#d78700" }, --[[VT220 yellow]]
    })[1]
)

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
map("n", "<leader>d", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>m", "<cmd>marks<CR>", { desc = "List all marks/bookmarks" })
map("n", "<leader>M", "<cmd>delmarks!<CR>", { desc = "Delete all lowercase marks/bookmarks" })
map("n", "<leader>y", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end, { desc = "Yank file path to clipboard" })
map("n", "<leader>c", function() -- alternatively, use `:vnew | read !cmd` and manually close the buffer
    vim.ui.input({ prompt = "$ " }, function(cmd)
        if not cmd or cmd == "" then return end
        vim.cmd("noswapfile vnew | setlocal buftype=nofile bufhidden=wipe filetype=sh scrolloff=0 nowrap")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(cmd))
    end)
end, { desc = "Run command in scratch buffer" })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.highlight.on_yank() end,
    desc = "Highlight when yanking text",
})
