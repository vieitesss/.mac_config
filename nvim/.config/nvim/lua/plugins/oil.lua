return {
    'stevearc/oil.nvim',
    -- lazy = false,
    event = "BufReadPre",
    name = 'oil',
    opts = {
        default_file_explorer = true,
        float = {
            max_width = 60,
            max_height = 30
        },
        keymaps = {
            ["<C-v>"] = "actions.select_vsplit"
        },
        view_options = {
            show_hidden = true
        }
    },
    keys = {
        { "<leader>pv", "<cmd>lua require('oil').open_float(\".\")<cr>" }
    }
}
