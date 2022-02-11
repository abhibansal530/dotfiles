{ config, lib, pkgs, ... }:

{
  home.packages = [
    pkgs.calibre
    pkgs.nyxt
  ];
}
