{ config, lib, pkgs, ... }:

{
  home.packages = [
    pkgs.calibre
    pkgs.filezilla
    pkgs.jellyfin-mpv-shim
    pkgs.mpv
    pkgs.nyxt
  ];
}
