local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- require('reacthelpers')
vim.g.mapleader = " "

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Break line
vim.opt.wrap = true
-- vim.opt.linebreak = true
-- vim.opt.listchars:append({ 'tabstop=4', 'extendedtabmoves=5', 'preceeds={, <as-one>, |}' })

vim.opt.hlsearch = false
vim.opt.incsearch = true
-- vim.opt.cursorline = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/.undo/"
vim.opt.undofile = true

vim.opt.scrolloff = 8

vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>")
vim.keymap.set("n", "<leader>f", "<cmd>Prettier<CR>")

vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("n", '<leader>c', vim.lsp.buf.code_action)
vim.keymap.set("n", '<leader>f', function() vim.lsp.buf.format { async = true } end)


--Dummy
vim.keymap.set("i", "<C-c>", "<Esc>")


vim.keymap.set("i", "(", "()<left>")
vim.keymap.set("i", "[", "[]<left>")
vim.keymap.set("i", "{", "{}<left>")
vim.keymap.set("i", "{<CR>", "{<CR>}<ESC>0")
vim.keymap.set("i", "{;<CR>", "{<CR>};<ESC>0")
vim.keymap.set("i", "\"", "\"\"<left>")
vim.keymap.set("i", "'", "''<left>")


vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

--rename highlighted text
vim.keymap.set("v", "<C-r>", '"hy:%s/<C-r>h//g<left><left>')


--Diagnostics
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_next)

--Make Exectutable
vim.keymap.set('n', '<leader>x', "<cmd>!chmod +x %<CR>")

--Quick list
vim.keymap.set('n', '<leader>cn', "<cmd>cnext<CR>")
vim.keymap.set('n', '<leader>cp', "<cmd>cprev<CR>")

vim.g.dap_virtual_text = true

vim.g.vim_svelte_plugin_load_full_syntax = 1
--
vim.g.termguicolors = true
--Nightfly
vim.g.nightflyTransparent = true
vim.g.nightflyVirtualTextColor = true

--Hide Netrw header
vim.g.netrw_banner = 0


-- sum all values

return require('lazy').setup("plugins")
