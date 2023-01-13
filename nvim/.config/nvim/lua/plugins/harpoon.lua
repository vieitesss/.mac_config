return {
    "ThePrimeagen/harpoon",
    keys = {
        { "<leader>hh", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", { silent = true } },
        { "<leader>hf", ":lua require('harpoon.mark').add_file()<cr>", { silent = true } },
        { "<leader>hn", ":lua require('harpoon.ui').nav_next()<cr>", { silent = true } },
        { "<leader>hp", ":lua require('harpoon.ui').nav_prev()<cr>", { silent = true } },
    }
}
