{ config, lib, pkgs, ... }:

{
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
}
