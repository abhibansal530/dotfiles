{ config, lib, pkgs, ... }:

with lib;
let userName = config._my.user.name;
in
{

  config = {
    assertions = [
      {
        assertion = isString userName && userName != "";
        message = "User name is empty.";
      }
    ];

    # Home-manager module config.
    home-manager.users.${userName} = {
      programs.rofi = {
        enable = true;
        package = pkgs.nur.repos.kira-bruneau.rofi-wayland;
        font = "SauceCodePro Nerd Font 12";
        terminal = "alacritty";
        extraConfig = {
          modi = "combi,drun,run";
          sidebar-mode = true;
          combi-mode = "drun,run";
        };
        theme = "${pkgs.nur.repos.kira-bruneau.rofi-wayland}/share/rofi/themes/Arc-Dark";
      };
    };
  };
}
