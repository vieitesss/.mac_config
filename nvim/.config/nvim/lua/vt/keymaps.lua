local keymap = vim.keymap.set
local s = { silent = true }
vim.g.mapleader = " "

----- Normal -----
------------------

--- save and quit
keymap("n", "<Leader>ww", ":w!<CR>")
keymap("n", "<Leader>q", ":q<CR>")
keymap("n", "<Leader>Q", ":wq<CR>")

--- no highlight
keymap("n", "<Leader>no", ":noh<CR>", s)

--- window movements
keymap("n", "<Leader>H", ":wincmd H<CR>")
keymap("n", "<Leader>J", ":wincmd J<CR>")
keymap("n", "<Leader>K", ":wincmd K<CR>")
keymap("n", "<Leader>L", ":wincmd L<CR>")
keymap("n", "<Leader>o", ":wincmd o<CR>")

keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

--- buffer movements
keymap("n", "<Leader>bp", ":bprev<CR>")
keymap("n", "<Leader>bn", ":bnext<CR>")
keymap("n", "<Leader>bd", ":bd<CR>")
keymap("n", "<Leader>bb", ":buffer")

--- split windows
keymap("n", "<Leader>sv", ":vsplit<CR>")
keymap("n", "<Leader>sh", ":split<CR>")
keymap("n", "<Leader>se", "<C-w>=")
keymap("n", "<Leader>sx", ":close<CR>")

--- reload file
keymap("n", "<Leader>so", ":so %<CR>", s)

----- Insert -----
------------------
--- quit
keymap("i", "jk", "<Esc>", {})

----- Visual -----
------------------

--- quit
keymap("v", "<Leader>o", "<Esc>", {})

--- paste without losing previous paste
keymap("v", "<Leader>p", '"_dP', {})

--- move lines
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '>-2<CR>gv=gv")

--- copy
keymap("x", "<C-c>", [["+y]], s)
