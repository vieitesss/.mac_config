-- Latex autocmd save and compile .tex
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.tex",
    callback = function()
        local file = vim.fn.expand("%:p")
        vim.cmd(":silent ! latexmk -cd -f -shell-escape -pdf " .. file)
        vim.cmd(":silent ! pkill -HUP mupdf")
        vim.cmd(":silent ! latexmk -c")
    end
})

-- Hide cmd input prompt when finished recording macro
vim.api.nvim_create_autocmd("RecordingLeave", {
    pattern = "*",
    callback = function()
        vim.api.nvim_exec2("set cmdheight=0", {})
    end
})

-- Show cmd input prompt where recording macro
vim.api.nvim_create_autocmd("RecordingEnter", {
    pattern = "*",
    callback = function()
        vim.api.nvim_exec2("set cmdheight=1", {})
    end
})

-- Highlight yanked text
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = highlight_group,
    pattern = '*',
})
