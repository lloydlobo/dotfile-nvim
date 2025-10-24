-- Sunburst color scheme for Neovim
-- Ported from Vim color file brightburn.vim
-- Original maintainer: Erik Bäckman
-- Original URL: https://github.com/erikbackman/brightburn.vim/

local M = {}

---Define color palette.
local c = {
    -- Base colors
    bg = { base = "#18181b", light = "#242424", lighter = "#333333" },
    fg = {
        base = "#dcdccc", --[[ muted = "#7f7f7f" ]]
    },

    -- Syntax colors
    yellow = { base = "#ffd787", muted = "#dfcfaf" },
    orange = { base = "#ffa263", light = "#ffcfaf" },
    red = { base = "#dca3a3", light = "#ecbcbc" },
    green = { base = "#acd2ac", dark = "#709080" },
    blue = { base = "#8cd0d3", light = "#9fafaf" },
    purple = { base = "#c0bed1" },

    -- UI colors
    gray = {
        base = "#8f8f8f",
        light = "#999999", --[[ dark = "#464646" ]]
    },
    beige = { base = "#efdcbc" },
}

function M.setup()
    --[[
        local termLacks256ColorSupport = (vim.fn.has 'gui_running' == 0)
        if false then termLacks256ColorSupport = termLacks256ColorSupport and (vim.opt.t_Co:get() <= 255) end
        if termLacks256ColorSupport then return end
    --]]

    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end

    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.g.colors_name = "brightburn_v1"

    -- Lambda function hi implements the Highlight command.
    --
    -- Unlike the `:highlight` command which can update a highlight group, this
    -- function completely replaces the definition.
    -- For example: `nvim_set_hl(0, 'Visual', {})` will clear the highlight group 'Visual'.
    -- See *:highlight* *:hi* *E28* *E411* *E415*
    --
    local hi = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end

    -- Highlight groups
    -----------------------------------------------------------------------
    -- Define colors
    hi("Boolean", { fg = c.orange.base, ctermfg = 215 })
    hi("Character", { fg = c.red.base, ctermfg = 181, bold = true })
    hi("Comment", { fg = c.green.base, ctermfg = 151 })
    hi("Conditional", { fg = c.yellow.base, ctermfg = 222, bold = true })
    hi("Constant", { fg = c.yellow.base, ctermfg = 222, bold = true })
    hi("Cursor", { fg = "#000d18", bg = "#8faf9f", ctermfg = 16, ctermbg = 109, bold = true })
    hi("Debug", { fg = "#bca3a3", ctermfg = 145, bold = true })
    hi("Define", { fg = c.orange.light, ctermfg = 223, bold = true })
    hi("Delimiter", { fg = c.gray.base, ctermfg = 102 })
    hi("DiffAdd", { fg = c.green.dark, bg = "#313c36", ctermfg = 66, ctermbg = 59, bold = true })
    hi("DiffChange", { bg = "#333333", ctermbg = 59 })
    hi("DiffDelete", { fg = "#333333", bg = "#464646", ctermfg = 59, ctermbg = 59 })
    hi("DiffText", { fg = "#ecbcbc", bg = "#41363c", ctermfg = 217, ctermbg = 59, bold = true })
    hi("Directory", { fg = "#9fafaf", ctermfg = 145, bold = true })
    hi("ErrorMsg", { fg = "#80d4aa", bg = "#2f2f2f", ctermfg = 115, ctermbg = 16, bold = true })
    hi("Exception", { fg = "#c3bf9f", ctermfg = 181, bold = true })
    hi("Float", { fg = "#c0bed1", ctermfg = 146 })
    hi("FoldColumn", { fg = "#93b3a3", bg = "#3f4040", ctermfg = 109, ctermbg = 59 })
    hi("Folded", { fg = "#93b3a3", bg = "#3f4040", ctermfg = 109, ctermbg = 59 })
    hi("Function", { fg = "#ffd787", ctermfg = 222 })
    hi("Identifier", { fg = "#efdcbc", ctermfg = 223 })
    hi("IncSearch", { fg = "#FFE636", bg = "#385f38", ctermfg = 228, ctermbg = 59 })
    hi("Keyword", { fg = "#ffd787", ctermfg = 222, bold = true })
    hi("Macro", { fg = "#ffcfaf", ctermfg = 223, bold = true })
    hi("ModeMsg", { fg = "#ffcfaf", ctermfg = 223 })
    hi("MoreMsg", { fg = "#ffffff", ctermfg = 231, bold = true })
    hi("Number", { fg = "#8cd0d3", ctermfg = 116 })
    hi("Operator", { fg = "#dcdccc", ctermfg = 230 })
    hi("PmenuSbar", { fg = "#000000", bg = "#2e3330", ctermfg = 16, ctermbg = 23 })
    hi("PmenuThumb", { fg = "#040404", bg = "#a0afa0", ctermfg = 16, ctermbg = 145 })
    hi("PreCondit", { fg = "#dfaf8f", ctermfg = 180, bold = true })
    hi("PreProc", { fg = "#ffcfaf", ctermfg = 223, bold = true })
    hi("Question", { fg = "#ffffff", ctermfg = 231, bold = true })
    hi("Repeat", { fg = "#ffd787", ctermfg = 222, bold = true })
    hi("Search", { fg = "#ffffe0", bg = "#284f28", ctermfg = 230, ctermbg = 22 })
    hi("SignColumn", { fg = "#9fafaf", ctermfg = 145, bold = true })
    hi("SpecialChar", { fg = "#dca3a3", ctermfg = 181, bold = true })
    hi("SpecialComment", { fg = "#82a282", ctermfg = 108, bold = true })
    hi("Special", { fg = "#ffd787", ctermfg = 222 })
    hi("SpecialKey", { fg = "#9ece9e", ctermfg = 151 })
    hi("Statement", { fg = "#ffd787", ctermfg = 222 })
    hi("StatusLine", { fg = "#dcdccc", bg = "#333333", ctermfg = 59, ctermbg = 186 })
    hi("StatusLineNC", { fg = "#7f7f7f", bg = "#262626", ctermfg = 23, ctermbg = 108 })
    hi("StorageClass", { fg = "#c3bf9f", ctermfg = 181, bold = true })
    hi("String", { fg = "#ffc1c1", ctermfg = 217 })
    hi("Structure", { fg = "#ffa263", ctermfg = 215, bold = true })
    hi("Tag", { fg = "#e89393", ctermfg = 174, bold = true })
    hi("Title", { fg = "#efefef", ctermfg = 231, bold = true })
    hi("Todo", { fg = "#dfdfdf", ctermfg = 188, bold = true })
    hi("Typedef", { fg = "#ffa263", ctermfg = 215, bold = true })
    hi("Type", { fg = "#ffa263", ctermfg = 215, bold = true })
    hi("Underlined", { fg = "#dcdccc", ctermfg = 188, underline = true })
    hi("VertSplit", { fg = "#2e3330", ctermfg = 23 })
    hi("VisualNOS", { fg = "#333333", bg = "#f18c96", ctermfg = 59, ctermbg = 210, bold = true, underline = true })
    hi("WarningMsg", { fg = "#ffffff", bg = "#333333", ctermfg = 231, ctermbg = 59, bold = true })
    hi("WildMenu", { fg = "#cbecd0", bg = "#2c302d", ctermfg = 194, ctermbg = 22, underline = true })

    -- Spellchecking
    hi("SpellBad", { fg = "#dc8c6c", ctermfg = 173 })
    hi("SpellCap", { fg = "#8c8cbc", ctermfg = 103 })
    hi("SpellRare", { fg = "#bc8cbc", ctermfg = 139 })
    hi("SpellLocal", { fg = "#9ccc9c", ctermfg = 151 })

    -- Basic
    hi("Normal", { fg = "#dcdccc", bg = "#18181b", ctermfg = 188, ctermbg = 16 })
    hi("Conceal", { fg = "#8f8f8f", bg = "#333333", ctermfg = 102, ctermbg = 59 })
    hi("ColorColumn", { bg = "#33332f", ctermbg = 58 })
    hi("CursorColumn", { bg = "#2b2b2b", ctermbg = 16, bold = true })
    hi("CursorLine", { bg = "#121212", ctermbg = 16, bold = true })
    hi("CursorLineNr", { fg = "#333333", bg = "#161616", ctermfg = 59, ctermbg = 16 })
    hi("FoldColumn", { bg = "#161616", ctermbg = 16 })
    hi("Folded", { bg = "#161616", ctermbg = 16 })
    hi("NonText", { fg = "#404040", ctermfg = 59, bold = true })
    hi("Pmenu", { fg = "#ccccbc", bg = "#242424", ctermfg = 187, ctermbg = 16 })
    hi("PmenuSel", { fg = "#ccdc90", bg = "#353a37", ctermfg = 186, ctermbg = 59, bold = true })
    hi("MatchParen", { fg = "#ffdf9f", bg = "#455445", ctermfg = 228, ctermbg = 59, bold = true })
    hi("SignColumn", { bg = "#181818", ctermbg = 16 })
    hi("SpecialKey", { bg = "#242424", ctermbg = 16 })
    hi("TabLine", { fg = "#88b090", bg = "#313633", ctermfg = 108, ctermbg = 59 })
    hi("TabLineSel", { fg = "#ccd990", bg = "#222222", ctermfg = 186, ctermbg = 16 })
    hi("TabLineFill", { fg = "#88b090", bg = "#313633", ctermfg = 108, ctermbg = 59 })
    hi("Error", { fg = "#e37170", bg = "#3d3535", ctermfg = 167, ctermbg = 59, bold = true })
    hi("Include", { fg = "#dfaf8f", ctermfg = 180, bold = true })
    hi("Label", { fg = "#dfcfaf", ctermfg = 187, underline = true })
    hi("Ignore", { fg = "#545a4f", ctermfg = 59 })
    hi("LineNr", { fg = "#999999", ctermfg = 102 })
    -----------------------------------------------------------------------

    -- Link highlight groups
    ----------------------------------------------------
    local link_groups = {
        ["Class"] = "Function",
        ["Import"] = "PythonInclude",
        ["Member"] = "Function",
        ["GlobalVariable"] = "Normal",
        ["GlobalConstant"] = "Constant",
        ["EnumerationValue"] = "Float",
        ["EnumerationName"] = "Identifier",
        ["DefinedName"] = "WarningMsg",
        ["LocalVariable"] = "WarningMsg",
        ["Structure"] = "WarningMsg",
        ["Union"] = "WarningMsg",
    }

    for newgroup, oldgroup in pairs(link_groups) do
        vim.api.nvim_set_hl(0, newgroup, { link = oldgroup })
    end
    ----------------------------------------------------

    -- Terminal colors
    ----------------------------------------------------
    -- if vim.fn.has('nvim') == 1 then
    --	local terminal_colors = {
    -- 	    '#1f1f1f', '#ac4142', '#90a959', c.yellow.bright,
    -- 	    '#6a9fb5', c.gray.main, '#75b5aa', c.fg.main,
    -- 	    '#6f6f6f', c.red.light, c.yellow.bright, '#6a9fb5',
    -- 	    c.gray.main, '#75b5aa', c.fg.main, c.orange.light
    -- 	}
    --	for i, color in ipairs(terminal_colors) do vim.g['terminal_color_' .. (i - 1)] = color end
    -- end

    if vim.fn.has("nvim") == 1 then
        -- bg = { base = '#18181b', light = '#242424', lighter = '#333333' },
        -- vim.g.terminal_color_0 = '#1f1f1f'
        vim.g.terminal_color_0 = "#282828"
        vim.g.terminal_color_1 = "#ac4142"
        vim.g.terminal_color_2 = "#90a959"
        vim.g.terminal_color_3 = "#f4bf75"
        vim.g.terminal_color_4 = "#6a9fb5"
        vim.g.terminal_color_5 = "#8f8f8f"
        vim.g.terminal_color_6 = "#75b5aa"
        vim.g.terminal_color_7 = "#dcdccc"
        vim.g.terminal_color_8 = "#6f6f6f"
        vim.g.terminal_color_9 = "#ecb3b3"
        vim.g.terminal_color_10 = "#f4bf75"
        vim.g.terminal_color_11 = "#6a9fb5"
        vim.g.terminal_color_12 = "#8f8f8f"
        vim.g.terminal_color_13 = "#75b5aa"
        vim.g.terminal_color_14 = "#dcdccc"
        vim.g.terminal_color_15 = "#ffcfaf"
    end
    ----------------------------------------------------
end

-- return M
-- OR
M.setup()
