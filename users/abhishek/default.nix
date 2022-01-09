{ config, inputs, lib, pkgs, ... }:

rec {
  fonts.fontconfig.enable = true;

  home = {
    username = "abhishek";
    homeDirectory = "/home/abhishek";

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
      pkgs.pdftk # For pdf operations
      pkgs.unzip

      # Custom scripts
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
  imports = [
    ../../modules/alacritty.nix
    ../../modules/git.nix
    ../../modules/gtk.nix
    ../../modules/vim.nix
    ../../modules/zsh.nix
  ];

  # Programs without much custom configuration.
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    brave = {
      enable = true;
    };

    emacs = {
      enable = false;
      package = pkgs.emacsPgtkGcc;
    };

    firefox = {
      enable = true;
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
