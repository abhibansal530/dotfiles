# Module to configure sway.

{ config, lib, pkgs, ... }:
with lib;
let cfg = config._my.desktop.sway;
    userName = config._my.user.name;
    my-clipman = import ./scripts/my_clipman.nix { inherit pkgs; };
    sway-focus-or-open = import ./scripts/focus_or_open.nix { inherit pkgs; };
    sway-auto-rename = import ./scripts/auto_rename.nix { inherit pkgs; };
in
{
  imports = [
  ];

  options._my.desktop.sway = {
    enable = mkOption {
      description = "Enable sway WM";
      type = types.bool;
      default = true;
    };
  };

  config = (mkIf cfg.enable) {
    assertions = [
      {
        assertion = isString userName && userName != "";
        message = "User name is empty.";
      }
    ];

    # NixOS module config.
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        brightnessctl
        imv # CLI image viewer
        swaylock
        swayidle
        waybar
        clipman # Wayland clipboard manager
        wl-clipboard
        qt5.qtwayland # Wayland support in Qt
        grim # Grab images from wayland compositor
        slurp # Select a region in wayland compositor
        sway-contrib.grimshot # Helper for screenshots in sway
        swappy # Wayland native snapshot editing tool.
      ];

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATOIN="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export GDK_BACKEND=wayland
        export CLUTTER_BACKEND=wayland
        export XDG_CURRENT_DESKTOP=Unity
      '';
    };

    # Home-manager module config.
    home-manager.users.${userName} = {
      imports = [
        # Waybar config.
        ./waybar.nix
      ];

      wayland.windowManager.sway = {
        enable = true;
        config = import ./config.nix { inherit config pkgs; };
        extraConfig = import ./extra.nix { inherit pkgs; };
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

      # Packages
      home.packages = [
        # Custom scripts
        my-clipman
        sway-focus-or-open
        sway-auto-rename
      ];


      # For notifications.
      # TODO : Refactor in a separate module.
      programs.mako = {
        enable = true;
        font = "SauceCodePro Nerd Font";
        backgroundColor = "#282828";
        textColor = "#FBF1C7";
        borderColor = "#4C7899";
        layer = "overlay"; # To show over fullscreen apps
      };
    };
  };
}
