return {
    "smjonas/inc-rename.nvim",
    config = true,
    keys = function ()
        require('inc_rename').setup()
        return{
            { "<leader>rn", ":IncRename " }
        }
    end
}
