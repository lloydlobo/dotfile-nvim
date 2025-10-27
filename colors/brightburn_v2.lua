-- See https://github.com/erikbackman/brightburn.vim/
-- Maintainer: Erik Bäckman
-- License: GNU GPL v3 (http://www.gnu.org/licenses/gpl.html)

-- Brightburn theme for Neovim (converted to Lua)

local cmd = vim.cmd
local set_hl = vim.api.nvim_set_hl

-- Exit early if terminal lacks color support
if not vim.fn.has("gui_running") == 1 and vim.o.t_Co <= 255 then return end

vim.o.background = "dark"
cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then cmd("syntax reset") end
vim.g.colors_name = "brightburn_v2"

-- Helper
local function hl(group, opts) set_hl(0, group, opts) end

hl("Boolean", { fg = "#ffa263" })
hl("Character", { fg = "#dca3a3", bold = true })
hl("Comment", { fg = "#333333" or "#999999" or "#acd2ac", bold = true })
hl("Conditional", { fg = "#ffd787", bold = true })
hl("Constant", { fg = "#ffd787", bold = true })
hl("Cursor", { fg = "#000d18", bg = "#8faf9f", bold = true })
hl("Debug", { fg = "#bca3a3", bold = true })
hl("Define", { fg = "#ffcfaf", bold = true })
hl("Delimiter", { fg = "#8f8f8f" })
hl("DiffAdd", { fg = "#709080", bg = "#313c36", bold = true })
hl("DiffChange", { bg = "#333333" })
hl("DiffDelete", { fg = "#333333", bg = "#464646" })
hl("DiffText", { fg = "#ecbcbc", bg = "#41363c", bold = true })
hl("Directory", { fg = "#9fafaf", bold = true })
hl("ErrorMsg", { fg = "#80d4aa", bg = "#2f2f2f", bold = true })
hl("Exception", { fg = "#c3bf9f", bold = true })
hl("Float", { fg = "#c0bed1" })
hl("FoldColumn", { fg = "#93b3a3", bg = "#3f4040" })
hl("Folded", { fg = "#93b3a3", bg = "#3f4040" })
hl("Function", { fg = "#ffd787" })
hl("Identifier", { fg = "#efdcbc" })
hl("IncSearch", { fg = "#FFE636", bg = "#385f38" })
hl("Keyword", { fg = "#ffd787", bold = true })
hl("Macro", { fg = "#ffcfaf", bold = true })
hl("ModeMsg", { fg = "#ffcfaf" })
hl("MoreMsg", { fg = "#ffffff", bold = true })
hl("Number", { fg = "#8cd0d3" })
hl("Operator", { fg = "#dcdccc" })
hl("PmenuSbar", { fg = "#000000", bg = "#2e3330" })
hl("PmenuThumb", { fg = "#040404", bg = "#a0afa0" })
hl("PreCondit", { fg = "#dfaf8f", bold = true })
hl("PreProc", { fg = "#ffcfaf", bold = true })
hl("Question", { fg = "#ffffff", bold = true })
hl("Repeat", { fg = "#ffd787", bold = true })
hl("Search", { fg = "#ffffe0", bg = "#284f28" })
hl("SignColumn", { fg = "#9fafaf", bold = true })
hl("SpecialChar", { fg = "#dca3a3", bold = true })
hl("SpecialComment", { fg = "#555555" or "#82a282", bold = true })
hl("Special", { fg = "#ffd787" })
hl("SpecialKey", { fg = "#9ece9e" })
hl("Statement", { fg = "#ffd787" })
hl("StatusLine", { fg = "#dcdccc", bg = "#333333" })
hl("StatusLineNC", { fg = "#7f7f7f", bg = "#262626" })
hl("StorageClass", { fg = "#c3bf9f", bold = true })
hl("String", { fg = "#d9e6a2" or "#ffc1c1" })
hl("Structure", { fg = "#ffa263", bold = true })
hl("Tag", { fg = "#e89393", bold = true })
hl("Title", { fg = "#efefef", bold = true })
hl("Todo", { fg = "#dfdfdf", bold = true })
hl("Typedef", { fg = "#ffa263", bold = true })
hl("Type", { fg = "#ffa263", bold = true })
hl("Underlined", { fg = "#dcdccc", underline = true })
hl("VertSplit", { fg = "#2e3330" })
hl("VisualNOS", { fg = "#333333", bg = "#f18c96", bold = true, underline = true })
hl("WarningMsg", { fg = "#ffffff", bg = "#333333", bold = true })
hl("WildMenu", { fg = "#cbecd0", bg = "#2c302d", underline = true })

-- Spellchecking
hl("SpellBad", { fg = "#dc8c6c" })
hl("SpellCap", { fg = "#8c8cbc" })
hl("SpellRare", { fg = "#bc8cbc" })
hl("SpellLocal", { fg = "#9ccc9c" })

-- Basic
hl("Normal", { fg = "#dcdccc", bg = "#18181b" })
hl("Conceal", { fg = "#8f8f8f", bg = "#333333" })
hl("ColorColumn", { bg = "#33332f" })
hl("CursorColumn", { bg = "#2b2b2b", bold = true })
hl("CursorLine", { bg = "#121212", bold = true })
hl("CursorLineNr", { fg = "#333333", bg = "#161616" })
hl("FoldColumn", { bg = "#161616" })
hl("Folded", { bg = "#161616" })
hl("NonText", { fg = "#404040", bold = true })
hl("Pmenu", { fg = "#ccccbc", bg = "#242424" })
hl("PmenuSel", { fg = "#ccdc90", bg = "#353a37", bold = true })
hl("MatchParen", { fg = "#ffdf9f", bg = "#455445", bold = true })
hl("SignColumn", { bg = "#181818" })
hl("SpecialKey", { bg = "#242424" })
hl("TabLine", { fg = "#88b090", bg = "#313633" })
hl("TabLineSel", { fg = "#ccd990", bg = "#222222" })
hl("TabLineFill", { fg = "#88b090", bg = "#313633" })
hl("Error", { fg = "#e37170", bg = "#3d3535", bold = true })
hl("Include", { fg = "#dfaf8f", bold = true })
hl("Label", { fg = "#dfcfaf", underline = true })
hl("Ignore", { fg = "#545a4f" })
hl("LineNr", { fg = "#999999" })

-- Links
cmd([[
  hi! link Class             Function
  hi! link Import            PythonInclude
  hi! link Member            Function
  hi! link GlobalVariable    Normal
  hi! link GlobalConstant    Constant
  hi! link EnumerationValue  Float
  hi! link EnumerationName   Identifier
  hi! link DefinedName       WarningMsg
  hi! link LocalVariable     WarningMsg
  hi! link Structure         WarningMsg
  hi! link Union             WarningMsg
]])

-- Terminal colors
if vim.fn.has("nvim-0.8") == 1 then
    vim.g.terminal_ansi_colors = {
        "#1f1f1f",
        "#ac4142",
        "#90a959",
        "#f4bf75",
        "#6a9fb5",
        "#8f8f8f",
        "#75b5aa",
        "#dcdccc",
        "#6f6f6f",
        "#ecb3b3",
        "#f4bf75",
        "#6a9fb5",
        "#8f8f8f",
        "#75b5aa",
        "#dcdccc",
        "#ffcfaf",
    }
elseif vim.fn.has("nvim-0.8") == 1 then
    hl("Terminal", { fg = "#a8a8a8", bg = "#0f0f0f" })
end
