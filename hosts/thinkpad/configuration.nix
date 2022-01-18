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

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_15;
    loader = {
      systemd-boot.consoleMode = "max";
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "thinkpad";
    networkmanager = {
      enable = true;
    };

    interfaces = {
      wlp0s20f3.useDHCP = true;
    };

    useDHCP = false;
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
    earlySetup = true;
  };

  # Enable sound.
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abhishek = {
    isNormalUser = true;
    shell = pkgs.zsh;
    home = "/home/abhishek";
    extraGroups = [
      "audio"
      "docker"
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
    ]; 
  };

  #environment.variables = {
  #  GDK_SCALE = "2";
  #  GDK_DPI_SCALE = "0.5";
  #  _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  #};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  #environment.variables = {
  #  SSH_ASKPASS = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
  #};

  environment.systemPackages = with pkgs; [
    brightnessctl
    coreutils
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    gnumake
    keychain
    ssh-askpass-fullscreen
    pulseaudio
    wget
    maestral # Dropbox client
    xfce.thunar # Graphical file manager
    pandoc
    slack
    spotify
    zoom-us

    # From overlays
    ## openvpn with aws patch
    openvpn
    update-systemd-resolved

    # Misc
    # xdg-utils (for things like xdg-open)
    # TODO : mimi doesn't work currently due to harcoded path (/usr/share/applications/ in its script).
    # (pkgs.xdg-utils.override { mimiSupport = true; })
    file

    # Dev
    docker

    ## Languages
    # Build
    bazel_4

    # cpp
    bear
    clang-tools
    gcc

    # go
    go
    gopls

    # Java
    jdk11_headless

    # python
    python39
  ];
  
  # Systemd services.
  systemd.user.services = {
    pipewire.wantedBy = [ "default.target" ];
    pipewire-pulse.wantedBy = [ "default.target" ];
    maestral = {
      description = "Maestral daemon";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.maestral.out}/bin/maestral start -f";
        ExecStop = "${pkgs.maestral.out}/bin/maestral stop";
        Restart = "on-failure";
        Nice = 10;
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      brightnessctl
      imv # CLI image viewer
      swaylock
      swayidle
      waybar
      clipman # Wayland clipboard manager
      wl-clipboard
      qt5.qtwayland # Wayland support in Qt
      grim # Grab images from wayland compositor
      slurp # Select a region in wayland compositor
      sway-contrib.grimshot # Helper for screenshots in sway
      swappy # Wayland native snapshot editing tool.
    ];

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATOIN="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export GDK_BACKEND=wayland
      export CLUTTER_BACKEND=wayland
      export XDG_CURRENT_DESKTOP=Unity
    '';
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  security.rtkit.enable = true;
  services = {
    blueman = {
      enable = true;
    };
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
    resolved.enable = true;
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

}

