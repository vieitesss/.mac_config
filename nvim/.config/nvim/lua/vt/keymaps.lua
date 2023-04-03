local keymap = vim.keymap.set
local s = { silent = true }

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
-- keymap("n", "<C-l>", ":wincmd l<CR>")
-- keymap("n", "<C-h>", ":wincmd h<CR>")
-- keymap("n", "<C-j>", ":wincmd j<CR>")
-- keymap("n", "<C-k>", ":wincmd k<CR>")

keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

--- buffer movements
keymap("n", "<Leader>bp", ":bprev<CR>")
keymap("n", "<Leader>bn", ":bnext<CR>")
keymap("n", "<Leader>bd", ":bd<CR>")
keymap("n", "<Leader>bb", ":buffer")

--- split windows
keymap("n", "<Leader>\\", ":vsplit<CR>")
keymap("n", "<Leader>-", ":split<CR>")
keymap("n", "<Leader>=", "<C-w>=")

--- reload file
keymap("n", "<Leader>so", ":so %<CR>", s)
keymap("n", "<Leader><Leader>e", ":e<CR>", s)

--- formatting
keymap("n", "<Leader>fo", ":lua vim.lsp.buf.format()<CR>", s)

--- pdfviewer
keymap("n", "<Leader>pdf", ":lua OPENPDFVIEWER()<CR>", s)

----- Insert -----
------------------
--- quit
keymap("i", "jk", "<Esc>")

-- delete word backwards
keymap("i", "<M-BS>", "<Esc>ciw")

----- Visual -----
------------------

--- quit
keymap("v", "<Leader>o", "<Esc>")

--- paste without losing previous paste
keymap("v", "<Leader>p", '"_dP')

--- move lines
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

--- copy
keymap("x", "<C-c>", [["+y]], s)
