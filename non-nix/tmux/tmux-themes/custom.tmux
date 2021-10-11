# MY CUSTOM THEME
#### BEGIN COLOUR

# default statusbar colors
set -g status-style fg='colour223',bg='colour237',default

# default window title colors
set -g window-status-style fg=brightblue,bg=default
#set-window-option -g window-status-attr dim

# active window title colors
set -g window-status-current-style fg=brightred,bg=default
#set-window-option -g window-status-current-attr bright

# pane border
set -g pane-border-style fg=black
set -g pane-active-border-style fg='colour223'

# message text
set -g message-style fg=brightred,bg=black

# pane number display
set-option -g display-panes-active-colour blue #blue
set-option -g display-panes-colour brightred #orange

# clock
set-window-option -g clock-mode-colour green #green

# bell
set-window-option -g window-status-bell-style fg=black,bg=red #base02, red

#### END COLOUR
