# Common home-manager config.

{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = [
      # User apps
      pkgs.keepassxc

      # Network utils
      pkgs.nmap

      # Misc utils
      pkgs.pdftk # For pdf operations
      pkgs.unzip

      # Media
      pkgs.spotify-unwrapped
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";
  };


  # Programs without much custom configuration.
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        forceWayland = true;
      };
    };

    zathura = {
      enable = true;
      options.selection-clipboard = "clipboard";
    };
  };
}
