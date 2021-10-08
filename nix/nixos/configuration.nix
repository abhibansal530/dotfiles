# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  # boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" "rivafb" "i2c_nvidia_gpu" ];
  # boot.extraModprobeConfig = ''
  #   options nouveau modeset=0
  # '';
  boot.loader.systemd-boot.consoleMode = "max";
  boot.kernelPackages = pkgs.linuxPackages_5_14;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "zephyrus"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;
  # networking.interfaces.enp4s0f4u1u1u2.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
    earlySetup = true;
    #font = "Lat2-Terminus16";
  };

  # Enable the X11 windowing system.
  # services.xserver = {
  #   enable = true;
  #   dpi = 192;
  #   displayManager = {
  #     lightdm.enable = true;
  #     defaultSession = "none+awesome";
  #     sessionCommands = ''
  #       ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
  #       Xft.dpi: 192
  #       EOF
  #     '';
  #   };
  #   windowManager.awesome.enable = true;

  #   synaptics.enable = true;
  #   synaptics.tapButtons = true;
  #   synaptics.vertEdgeScroll = true;
  #   synaptics.vertTwoFingerScroll = true;
  #   synaptics.fingersMap = [1 3 2];
  #   synaptics.additionalOptions = ''
  #     Option "RBCornerButton" "3"
  #   '';
  # };

  # services.redshift = {
  #   enable = true;
  #   brightness = {
  #     day = "1";
  #     night = "1";
  #   };
  #   temperature = {
  #     day = 5500;
  #     night = 3700;
  #   };
  #   latitude = "29.96";
  #   longitude = "74.71";
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abhi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    coreutils
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    maestral # Dropbox client
    # pulseaudio
    #sway-borders-git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      brightnessctl
      swaylock
      swayidle
      waybar
      wl-clipboard
      wofi
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

  # systemd.user.target.sway-session = {
  #   description = "Sway compositor session";
  #   documentation = ["man:systemd.special(7)"];
  #   bindTo = [ "graphical-session.target" ];
  #   wants = [ "graphical-session-pre.target" ];
  #   after = [ "graphical-session-pre.target" ];
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

