{ config, inputs, lib, pkgs, ... }:
let
  sway-focus-or-open = import ./modules/sway/scripts/focus_or_open.nix { inherit pkgs; };
  sway-auto-rename = import ./modules/sway/scripts/auto_rename.nix { inherit pkgs; };
in
{
  fonts.fontconfig.enable = true;

  home = {
    username = "abhi";
    homeDirectory = "/home/abhi";

    packages = [
      (pkgs.nerdfonts.override { fonts = [ "Iosevka" "SourceCodePro" ]; })
      (pkgs.powerline-fonts)
      (pkgs.ripgrep)
      (pkgs.clang)
      (pkgs.fd)
      (pkgs.sqlite) # For org-roam
      (pkgs.keepassxc)

      # Network utils
      pkgs.nmap

      # Misc utils
      pkgs.calibre
      pkgs.pdftk # For pdf operations
      pkgs.unzip

      # Custom scripts
      sway-focus-or-open
      sway-auto-rename
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.05";
  };

  # Import per program config.
  imports = [ ./modules ];

  # Programs without much custom configuration.
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
    };

    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        forceWayland = true;
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    tmux = {
      enable = true;
      shell = "\${pkgs.zsh}/bin/zsh";
      terminal = "xterm-256color";
    };

    zathura = {
      enable = true;
      options.selection-clipboard = "clipboard";
    };
  };
}
