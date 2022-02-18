# This file defines common NixOS config shared across all hosts.

{ inputs, system, nixpkgs, hostName, hostUserName, ... }:

with builtins;
let
  lib = inputs.nixpkgs.lib;
  valid = (isString hostName) && (isString hostUserName) &&
          hostName != "" && hostUserName != "";
in
{
  imports = [
    # My modules.
    ./modules
  ];

  config = lib.mkAssert valid "Invalid config" {
    nix = {
      # Default Nix expression search path, used to lookup for paths in angle brackets (eg. <nixpkgs>).
      nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
        "home-manager=${inputs.home-manager}"
      ];

      # Nix package instance to use througout the system.
      package = nixpkgs.nixFlakes;

      # System-wide flake registry.
      # registry = {};

      # Additional text appended to nix.conf.
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    nixpkgs = {
      # If nixpkgs.pkgs is set then 'pkgs' argument to all modules will use that.
      pkgs = nixpkgs;
    };

    boot = {
      loader = {
        systemd-boot.consoleMode = "max";
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    networking = {
      hostName = hostName;
      networkmanager = {
        enable = true;
      };

      useDHCP = false;
    };

    time.timeZone = "Asia/Kolkata";


    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "${nixpkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
      keyMap = "us";
      earlySetup = true;
    };

    # Enable sound.
    hardware.bluetooth.enable = true;
    hardware.pulseaudio.enable = false; # Use pipewire.

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${hostUserName} = {
      isNormalUser = true;
      home = "/home/${hostUserName}";
      shell = nixpkgs.zsh;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "audio"
        "docker"
      ];
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with nixpkgs; [
      alacritty
      coreutils
      gnumake
      jq
      vim
      wget
      maestral # Dropbox client
      python39
      xfce.thunar # Graphical file manager
      zoom-us

      # Dev
      docker

      ## Languages
      # cpp
      bear
      clang
      clang-tools
      gcc

      # go
      go_1_17
      gopls

      # Misc
      file
      pandoc
      killall

      # SSH Askpass
      keychain
      ssh-askpass-fullscreen
    ];


    # Systemd services.
    systemd.user.services.maestral = {
      description = "Maestral daemon";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${nixpkgs.maestral.out}/bin/maestral start -f";
        ExecStop = "${nixpkgs.maestral.out}/bin/maestral stop";
        Restart = "on-failure";
        Nice = 10;
      };
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = with nixpkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        gtkUsePortal = true;
      };
    };


    # Required for pipewire.
    security.rtkit.enable = true;

    services = {
      blueman.enable = true;

      greetd = {
        enable = true;
        vt = 2;
        settings = {
          default_session = {
            command = "${lib.makeBinPath [nixpkgs.greetd.tuigreet] }/tuigreet --time --cmd sway-run";
            user = "greeter";
          };
        };
      };

      # Pipewire config (taken from NixOS wiki).
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        media-session.config.bluez-monitor.rules = [
          {
            # Matches all cards
            matches = [ { "device.name" = "~bluez_card.*"; } ];
            actions = {
              "update-props" = {
                "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                # mSBC is not expected to work on all headset + adapter combinations.
                "bluez5.msbc-support" = true;
                # SBC-XQ is not expected to work on all headset + adapter combinations.
                "bluez5.sbc-xq-support" = true;
              };
            };
          }
          {
            matches = [
              # Matches all sources
              { "node.name" = "~bluez_input.*"; }
              # Matches all outputs
              { "node.name" = "~bluez_output.*"; }
            ];
            actions = {
              "node.pause-on-idle" = false;
            };
          }
        ];
      };
    };

    # Enable docker service.
    virtualisation.docker.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "21.11"; # Did you read the comment?

    # Config from my modules.
    _my.user.name = hostUserName;
  };
}
