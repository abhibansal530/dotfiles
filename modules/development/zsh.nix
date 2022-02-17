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
      programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        initExtra = ''
          export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
          ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=25

          export EDITOR='vim'

          # Use Rg for file searcing in fzf
          export FZF_DEFAULT_COMMAND="${pkgs.ripgrep}/bin/rg --files --hidden --follow"
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

          # Key bindings
          bindkey '^ ' autosuggest-accept
        '';

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
          ];
          theme = "agnoster";
        };

        shellAliases = {
          userctl = "systemctl --user";
          k = "kubectl";
        };
      };
    };
  };
}
