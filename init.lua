local opt, map = vim.opt, vim.keymap.set

opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.laststatus = 0
opt.undofile = true

opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = opt.shiftwidth:get()
opt.tabstop = 4

-- • See also: https://www.masswerk.at/nowgobang/2019/dec-crt-typography
-- • colorscheme {lunaperche,retrobox,wildcharm,zaibatsu} | ... guibg=#231e1b
vim.cmd("syntax off | colorscheme retrobox | highlight Normal guifg=#ffaf00 guibg=#282828")

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
map("n", "<space>y", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end, { desc = "Yank file path to clipboard" })
map("n", "<space>c", function() -- alternatively, use `:vnew | read !cmd` and manually close buffer
    vim.ui.input({ prompt = "$ " }, function(cmd)
        if not cmd or cmd == "" then return end
        vim.cmd("noswapfile vnew | setlocal buftype=nofile bufhidden=wipe filetype=sh scrolloff=0 nowrap")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(cmd))
    end)
end, { desc = "Run command in scratch buffer" })
