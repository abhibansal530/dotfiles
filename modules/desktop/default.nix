# Desktop module.

{ config, lib, pkgs, ... }:
{
  imports = [
    ./gammastep.nix
    ./gtk.nix
    ./rofi.nix
    ./sway
  ];
}
