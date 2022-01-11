{ pkgs }:

# Helper script to prevent auto enable of laptop display in clamshell mode.
# https://github.com/swaywm/sway/wiki#clamshell-mode

pkgs.writeShellScriptBin "sway-clamshell-helper" ''
LAPTOP="eDP-1"
if grep -q open /proc/acpi/button/lid/LID/state; then
    swaymsg output $LAPTOP enable
else
    swaymsg output $LAPTOP disable
fi
''
