{ config, lib, pkgs, ... }:

{
  programs.mako = {
    enable = true;
    font = "SauceCodePro Nerd Font";
    backgroundColor = "#282828";
    textColor = "#FBF1C7";
    borderColor = "#4C7899";
    layer = "overlay"; # To show over fullscreen apps
  };
}
