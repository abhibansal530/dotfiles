{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./tmux.nix
  ];
}
