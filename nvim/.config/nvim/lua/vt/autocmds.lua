-- -- Status line
-- vim.api.nvim_create_autocmd("BufEnter", {
-- pattern = "*",
-- callback = function()
-- vim.api.nvim_command("set laststatus=3")
-- end,
-- })

-- Latex autocmd save and compile .tex
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.tex",
    callback = function()
        local dir = vim.fn.expand("%:p:h")
        local file = vim.fn.expand("%")
        -- print(":silent ! latexmk -f -shell-escape -cd -pdf " .. vim.fn.expand("%:p") .. " > /dev/null")
        vim.cmd(":silent ! cd " .. dir .. " && latexmk -f -shell-escape -pdf ./" .. file)
    end
})

--------- Do not show numbers in not focused windows
vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "*",
    callback = function()
        -- vim.api.nvim_exec2("set number", {})
        vim.api.nvim_exec2("set relativenumber", {})
    end
})

vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function()
        -- vim.api.nvim_exec2("set nonumber", {})
        vim.api.nvim_exec2("set norelativenumber", {})
    end
})
---------

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

-- vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = "*.md",
--     callback = function()
--         vim.api.nvim_exec2("lua require('richmd').markdownPreview()", {})
--     end
-- })

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- pattern = { "*.js", "*.c", "*.h", "*.lua", "*.sh", "*.java" },
-- callback = function()
-- vim.lsp.buf.format()
-- end,
-- })
