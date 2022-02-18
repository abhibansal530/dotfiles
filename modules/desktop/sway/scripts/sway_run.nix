{ pkgs }:

# Ref.: https://man.sr.ht/~kennylevinsen/greetd/#how-to-set-xdg_session_typewayland

pkgs.writeShellScriptBin "sway-run" ''
# Session
export XDG_SESSION_TYPE=wayland;
export XDG_SESSION_DESKTOP=sway;
export XDG_CURRENT_DESKTOP=sway;

# Wayland enablement
export QT_QPA_PLATFORM=wayland;
export GDK_BACKEND=wayland;
export SDL_VIDEODRIVER=wayland;
export QT_WAYLAND_DISABLE_WINDOWDECORATOIN=1;
export _JAVA_AWT_WM_NONREPARENTING=1;
export MOZ_ENABLE_WAYLAND=1;
export CLUTTER_BACKEND=wayland;

# Misc
unset __HM_SESS_VARS_SOURCED __NIXOS_SET_ENVIRONMENT_DONE # otherwise sessionVariables are not updated
export SSH_ASKPASS="/run/current-system/sw/bin/ssh-askpass-fullscreen";

# Start keyring
eval $(keychain --eval --quiet --confhost)

# Start sway
systemd-cat --identifier=sway sway $@
''
