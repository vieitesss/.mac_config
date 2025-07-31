# techbase-tmux-theme plugin
# Color palette (from https://github.com/mcauley-penney/techbase.nvim theme)
set -g @color_fg "#CCD5E5"
set -g @color_bg "#191d23"
set -g @color_bg_alt "#20252E"
set -g @color_comment "#474B65"
set -g @color_accent "#6A8BE3"
set -g @color_number "#B85B53"
set -g @color_operator "#b09884"

# Use True Color if possible
set-option -ga terminal-overrides ",xterm-256color:Tc"

# Status bar
set-option -g status-style "fg=#{@color_fg},bg=#{@color_bg}"
# set-option -g status-bg "#{@color_bg}"
# set-option -g status-fg "#{@color_fg}"

# Active window title
set-window-option -g window-status-current-style "fg=#{@color_accent},bg=#{@color_bg_alt},bold"
set-window-option -g window-status-current-format " #I:#W#F "

# Inactive window title
set-window-option -g window-status-style "fg=#{@color_comment},bg=#{@color_bg}"
set-window-option -g window-status-format " #I:#W#F "

# Pane border
set-option -g pane-border-style "fg=#{@color_operator},bg=#{@color_bg}"
set-option -g pane-active-border-style "fg=#{@color_accent},bg=#{@color_bg}"

# Message styling (for copy mode, prompts, etc)
set-option -g message-style "fg=#{@color_fg},bg=#{@color_bg_alt}"
set-option -g message-command-style "fg=#{@color_accent},bg=#{@color_bg_alt}"

# Mode-style (copy mode indicator)
set-option -g mode-style "fg=#{@color_bg},bg=#{@color_accent},bold"

# Clock mode colors
set-window-option -g -F clock-mode-colour "#{@color_number}"
set-window-option -g clock-mode-style 24

# Bell color
set-option -g bell-action any
# set-option -g bell-on-alert on
# set-option -g bell-style "fg=#F71735,bg=#{@color_bg_alt}"
