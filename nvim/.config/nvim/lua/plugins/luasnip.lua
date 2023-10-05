return {
    "L3MON4D3/LuaSnip",
    lazy = false,
    config = function ()
        local ls = require("luasnip")
        require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/"})

        ls.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
        })
    end,
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    }
}
