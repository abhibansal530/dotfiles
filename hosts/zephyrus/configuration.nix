{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    interfaces = {
      wlp2s0.useDHCP = true;
    };
  };
}
