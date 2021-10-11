{ config, lib, pkgs, ... }:

{
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
}
