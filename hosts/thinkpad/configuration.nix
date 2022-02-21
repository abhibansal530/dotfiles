{ config, lib, pkgs, ... }:

let
  slack = pkgs.slack.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      rm $out/bin/slack
      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    '';
  });

  aws-connect = import ./scripts/aws_vpn_connect.nix { inherit pkgs; };

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_15;
  };

  networking = {
    interfaces = {
      wlp0s20f3.useDHCP = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # Dev
    jdk11_headless # Required by bazel somehow
    bazel_4

    # Misc apps
    slack

    ## For AWS VPN.
    aws-connect
    openvpn_aws

    ## K8
    minikube
    kubernetes-helm
    kubectl

    ## Dev utils.
    awscli2
  ];

  # Required for Openvpn (for AWS VPN).
  services.resolved.enable = true;

  # Config for my modules.
  _my.default-browser = "chromium";
  _my.desktop.sway.extraConfig = {
    output = {
      "eDP-1" = {
        mode = "1920x1200@60.001Hz";
        scale = "1.5";
        subpixel = "rgb";
        adaptive_sync = "on";
      };

      "DP-2" = {
        mode = "3840x2160@60.000Hz";
        scale = "2";
        subpixel = "rgb";
        adaptive_sync = "on";
      };
    };

    # TODO : Refactor startup apps in sway module.
    # Input will be (app_window_id, app_id, app_command)
    assigns = {
      "10" = [{ app_id = "Slack"; }];
    };

    startup = [
      { command = "slack"; }
    ];

    keybindings = {
      "Mod4+F2" = "exec sway-focus-or-open Slack slack";
    };
  };
}
