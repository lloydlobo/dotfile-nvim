local M = {}
function M.setup()
    vim.keymap.set("n", "<leader>f", function(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        local filetypes = { bash = "shfmt", fsharp = "fantomas", markdown = "prettier", lua = "stylua" }
        local filename, ext =
            vim.api.nvim_buf_get_name(bufnr), vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e")
        if filename == "" or not filetypes[ext] or vim.fn.system("which " .. filetypes[ext]) == "" then
            return vim.notify("Error: save or missing formatter", vim.log.levels.ERROR)
        end
        vim.cmd("write")
        vim.fn.system(filetypes[ext] .. " " .. vim.fn.shellescape(filename))
        vim.cmd("edit")
        vim.notify("Formatted: " .. filename)
    end, { buffer = 0 })
end
return M
