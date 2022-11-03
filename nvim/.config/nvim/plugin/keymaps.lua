local keymap = vim.keymap.set
local s = { silent = true }
vim.g.mapleader = ' '

----- Normal -----
------------------

-- save and quit
keymap('n', '<Leader>ww', ':w!<CR>')
keymap('n', '<Leader>q', ':q<CR>')
keymap('n', '<Leader>Q', ':wq<CR>')

-- no highlight
keymap('n', '<Leader>no', ':noh<CR>', s)

-- window movements
keymap('n', '<Leader>H', ':wincmd H<CR>')
keymap('n', '<Leader>J', ':wincmd J<CR>')
keymap('n', '<Leader>K', ':wincmd K<CR>')
keymap('n', '<Leader>L', ':wincmd L<CR>')
keymap('n', '<Leader>o', ':wincmd o<CR>')

-- buffer movements
keymap('n', '<Leader>bp', ':bprev<CR>')
keymap('n', '<Leader>bn', ':bnext<CR>')
keymap('n', '<Leader>bd', ':bd<CR>')
keymap('n', '<Leader>bb', ':buffer')

-- split windows
keymap('n', '<Leader>sv', ':vsplit<CR>')
keymap('n', '<Leader>sh', ':split<CR>')
keymap('n', '<Leader>se', '<C-w>=')
keymap('n', '<Leader>sx', ':close<CR>')

-- vim-maximizer
keymap('n', '<Leader>sm', ':MaximizerToggle<CR>')

-- reload file
keymap('n', '<Leader>so', ':so %<CR>', s)

-- Run File
keymap('n', '<Leader>rf', '<cmd>RunCode<CR>', s)

-- Treesitter
keymap('n', '<Leader>rt', '<cmd>e<CR>', s)

-- packer
keymap('n', '<Leader>ps', ':PackerSync<CR>')

-- lsp

-- nvim-tree
keymap('n', '<Leader>pv', ':NvimTreeToggle<CR>', s)

-- telescope
keymap('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
keymap('n', '<Leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
keymap('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
keymap('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
keymap('n', '<Leader>fp', [[<cmd>lua require('telescope').extensions.project.project()<CR>]])
keymap('n', '<Leader>dot', [[:lua require'vt.telescope'.search_dotfiles()<CR>]], s)
keymap('n', '<Leader>pro', [[:lua require'vt.telescope'.search_projects()<CR>]], s)
keymap('n', '<Leader>nv', [[:lua require'vt.telescope'.search_nvim()<CR>]], s)
-- keymap('n', '<Leader>pv', [[<cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>]], s)

-- floaterm
keymap('n', '<Leader>ft', ':FloatermNew<CR>', s)
keymap('n', '<Leader>t', ':FloatermToggle<CR>', s)
keymap('t', 'jk', '<C-\\><C-n>', s)

----- Insert -----
------------------
-- quit
keymap('i', 'jk', '<Esc>', {})

----- Visual -----
------------------

-- quit
keymap('v', '<Leader>o', '<Esc>', {})

-- paste without losing previous paste
keymap('v', '<Leader>p', '\"_dP', {})

-- move lines
keymap('v', 'J', ':m \'>+1<CR>gv=gv')
keymap('v', 'K', ':m \'>-2<CR>gv=gv')

-- copy
keymap('x', '<C-c>', [["+y]], s)
