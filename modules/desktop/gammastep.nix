{ config, lib, pkgs, ... }:
with lib;
let cfg = config._my.desktop.night-light;
    userName = config._my.user.name;
in
{
  imports = [
  ];

  options._my.desktop.night-light = {
    enable = mkOption {
      description = "Enable blue light filter";
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

    # Home-manager module config.
    home-manager.users.${userName} = {
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
            gamma = "0.85:0.8:0.75";
          };
          randr = {
            screen = 0;
          };
        };
        temperature = {
          day = 3300;
          night = 3200;
        };
      };
    };
  };
}
