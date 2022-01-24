{ config, lib, pkgs, ... }:

with lib;
let cfg = config._my.desktop.gtk;
    userName = config._my.user.name;
in
{

  imports = [
  ];

  options._my.desktop.gtk = {
    enable = mkOption {
      description = "Enable GTK";
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
      gtk = {
        enable = true;
        font.name = "sans-serif 10";
        theme = {
          package = pkgs.gnome-themes-extra;
          name = "Adwaita";
        };
        iconTheme = {
          package = pkgs.gnome3.adwaita-icon-theme;
          name = "Adwaita";
        };
        # Tooltips remain visible when switching to another workspace
        gtk2.extraConfig = ''
          gtk-enable-tooltips = 0
        '';
        gtk3.bookmarks = [
          "file:///tmp"
        ];
      };
    };
  };
}
