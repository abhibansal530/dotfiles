{ config, lib, pkgs, ... }:

{
  home.packages = [
    pkgs.calibre
    pkgs.filezilla
    pkgs.nyxt
  ];
}
