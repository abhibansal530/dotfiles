{ config, lib, pkgs, ... }:

{
  home.packages = [
  ];

  programs = {
    chromium = {
      enable = true;
      package = pkgs.chromium.override {
        commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    };
  };
}
