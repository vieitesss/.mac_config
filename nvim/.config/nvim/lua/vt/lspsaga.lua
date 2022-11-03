local status_saga, saga = pcall(require, "lspsaga")
if not status_saga then return end

saga.init_lsp_saga({
  move_in_saga = { prev = "<C-k>", next = "<C-j>"},
  finder_action_keys = {
    open = "<CR>"
  },
  definition_action_keys = {
    edit = "<CR>"
  }
})
