{ config, lib, pkgs, ... }:

with lib;
let userName = config._my.user.name;
in
{
  imports = [
    ./terminal
    ./zsh.nix
  ];

  config = {
    assertions = [
      {
        assertion = isString userName && userName != "";
        message = "User name is empty.";
      }
    ];

    # Home-manager module config.
    home-manager.users.${userName} = {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.git = {
        enable = true;
        aliases = {
          co = "checkout";
          cp = "cherry-pick";
          sh = "show";
          st = "status";
        };
        userName = "Abhishek Bansal";
        userEmail = "abhibansal530@gmail.com";
      };

      home.packages = [
        (pkgs.nerdfonts.override { fonts = [ "Iosevka" "SourceCodePro" ]; })
        pkgs.powerline-fonts
        pkgs.ripgrep
        pkgs.fd
      ];
    };
  };
}
