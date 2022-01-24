{ config, lib, pkgs, ... }:

with lib;
let userName = config._my.user.name;
in
{

  config = {
    assertions = [
      {
        assertion = isString userName && userName != "";
        message = "User name is empty.";
      }
    ];

    # Home-manager module config.
    home-manager.users.${userName} = {
      programs.emacs = {
        enable = true;
        package = pkgs.emacsPgtkGcc;
      };

      home.packages = [
        (pkgs.sqlite) # For org-roam
      ];
    };
  };
}
