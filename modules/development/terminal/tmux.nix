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
      programs.tmux = {
        enable = true;
        shell = "\${pkgs.zsh}/bin/zsh";
        terminal = "xterm-256color";

        # TODO : More config.
      };
    };
  };
}
