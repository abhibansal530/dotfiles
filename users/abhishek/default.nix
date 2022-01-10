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
    ../../modules/rofi.nix
    ../../modules/sway
  ];

  # Programs without much custom configuration.
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    brave = {
      enable = true;
    };

    emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
    };

    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        forceWayland = true;
        extraPolicies = {
          ExtensionSettings = {};
        };
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

    autorandr = {
      enable = true;
      profiles = {
        "laptop" = {
          fingerprint = {
            "eDP-1" = "Thinkpad";
          };
          config = {
            "eDP-1" = {
              enable = true;
              primary = true;
              mode = "1920x1200";
            };
            "HDMI-1" = {
              enable = false;
            };
          };
        };

        "laptop-dual" = {
          fingerprint = {
            "eDP-1" = "Thinkpad";
            "HDMI-1" = "MSI";
          };
          config = {
            "eDP-1" = {
              enable = false;
            };
            "HDMI-1" = {
              enable = true;
              primary = true;
              mode = "1920x1080";
              rate = "144.00";
            };
          };
        };
      };
    };
  };
}
