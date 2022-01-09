{ config, lib, pkgs, ... }:

{
  imports = [
    ./gammastep.nix
    ./mako.nix
    ./waybar.nix
    ./workstyle.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = import ./sway.nix { inherit config pkgs; };
    extraConfig = import ./sway_extra.nix { inherit pkgs; };
  };

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATOIN = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;
    MOZ_ENABLE_WAYLAND = 1;
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  # Start on tty1
  programs.zsh.initExtra = ''
    if [[ $(tty) = /dev/tty1 ]]; then
      export XDG_SESSION_TYPE="wayland" # otherwise set to tty
      unset __HM_SESS_VARS_SOURCED __NIXOS_SET_ENVIRONMENT_DONE # otherwise sessionVariables are not updated
      exec sway
    fi
  '';
}
