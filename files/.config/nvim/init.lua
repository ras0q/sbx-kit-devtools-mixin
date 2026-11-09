vim.cmd.colorscheme("catppuccin")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.number = true
vim.o.cursorline = true
vim.o.title = true
vim.o.titlestring = " %{fnamemodify(getcwd(), ':t')} %m"
vim.o.wrap = false
vim.o.breakindent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.wildoptions = "pum"
vim.o.wildmode = "noselect:lastused,full"
vim.o.completeopt = "fuzzy,popup,menuone,noinsert"
vim.o.pumheight = 15
vim.o.winborder = "rounded"

vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_banner = 0

vim.keymap.set("n", "<leader>e", "<Cmd>Lexplore<CR>", { desc = "Toggle file tree" })
vim.keymap.set({ "n", "x" }, "gh", "^")
vim.keymap.set({ "n", "x" }, "gl", "$")
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<Plug>(esc)<ESC>", "i<ESC>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n><Plug>(esc)")

require("find")
require("grep")
require("lsp")
