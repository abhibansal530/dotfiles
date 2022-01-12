{ config, lib, pkgs, ... }:

{
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
    extraConfig = {
      url = {
        "git@github.com:" = { insteadOf = "https://github.com/"; };
      };
    };
  };
}
