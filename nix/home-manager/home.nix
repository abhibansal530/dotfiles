{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "abhi";
  home.homeDirectory = "/home/abhi";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  fonts.fontconfig.enable = true;

  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "Iosevka" "SourceCodePro" ]; })
    (pkgs.powerline-fonts)
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = import ./config/alacritty.nix;
    };

    git = {
      enable = true;
      userName = "Abhishek Bansal";
      userEmail = "abhibansal530@gmail.com";
    };

    waybar = {
      enable = true;
      settings = [{
        layer = "bottom";
        position = "bottom";
        height = 15;
        modules-left = [ "sway/workspaces" ];
        modules-right = [ "network" "pulseaudio" "battery" "clock" ];
        modules = import ./config/waybar/modules.nix;
      }];

      style = import ./config/waybar/style.nix;
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      initExtra = ''
        if [[ $(tty) = /dev/tty1 ]]; then
          export XDG_SESSION_TYPE="wayland" # otherwise set to tty
          exec sway
        fi
      '';
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = import ./config/sway/sway.nix { inherit pkgs; };
    extraConfig = import ./config/sway/sway_extra.nix { inherit pkgs; };
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = "29.96";
    longitude = "74.71";
    settings = {
      general = {
        adjustment-method = "wayland";
        brightness-day = 0.9;
        brightness-night = 1.0;
      };
      randr = {
        screen = 0;
      };
    };
    temperature = {
      day = 4100;
      night = 4000;
    };
  };

}
