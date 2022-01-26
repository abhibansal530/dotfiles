# My modules for configuring NixOS.

{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./desktop
    ./development
    ./editor
  ];

  options._my.default-browser = mkOption {
    description = "Default browser to use";
    type = types.enum [ "firefox" "chromium" ];
    default = "firefox";
  };

  options._my.user = {
    name = mkOption {
      description = "User name";
      type = types.str;
      default = "";
    };
  };
}
