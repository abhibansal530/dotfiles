{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_14;
    loader = {
      systemd-boot.consoleMode = "max";
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "zephyrus";
    networkmanager = {
      enable = true;
    };

    interfaces = {
      wlp2s0.useDHCP = true;
    };

    useDHCP = false;
  };

  time.timeZone = "Asia/Kolkata";


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
    earlySetup = true;
    #font = "Lat2-Terminus16";
  };

  # Enable sound.
  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abhi = {
    isNormalUser = true;
    home = "/home/abhi";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "audio"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    brightnessctl
    coreutils
    gnumake
    jq
    vim
    wget
    maestral # Dropbox client
    pulseaudio
    python39
    xfce.thunar # Graphical file manager
  ];


  # Systemd services.
  systemd.user.services.maestral = {
    description = "Maestral daemon";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.maestral.out}/bin/maestral start -f";
      ExecStop = "${pkgs.maestral.out}/bin/maestral stop";
      Restart = "on-failure";
      Nice = 10;
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

  services.blueman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
