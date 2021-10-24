{ config, lib, pkgs, ... }:

let
  tomlFormat = pkgs.formats.toml {  };

  # Mapping between application name and its icon.
  workstyle-cfg = {
    "Alacritty" = "";
    "termite" = "";
    "github" = "";
    "rust" = "";
    "google" = "";
    "private browsing" = "";
    "firefox" = "";
    "chrome" = "";
    "file manager" = "";
    "libreoffice calc" = "";
    "libreoffice writer" = "";
    "libreoffice" = "";
    "nvim" = "";
    "gthumb" = "";
    "menu" = "";
    "calculator" = "";
    "transmission" = "";
    "videostream" = "";
    "mpv" = "";
    "music" = "";
    "disk usage" = "";
    ".pdf" = "";
  };
in
{
  xdg.configFile."workstyle/config.toml" = {
    source = tomlFormat.generate "workstyle-config" workstyle-cfg;
  };
}
