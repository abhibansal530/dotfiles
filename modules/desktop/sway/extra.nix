{ pkgs }:


''
# https://github.com/swaywm/sway/wiki#clamshell-mode
set $laptop eDP-1
bindswitch --reload --locked lid:on output $laptop disable
bindswitch --reload --locked lid:off output $laptop enable
''
