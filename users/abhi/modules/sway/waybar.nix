{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    style = import ./waybar_style.nix;
    settings = [{
      layer = "bottom";
      position = "bottom";
      height = 15;
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-right = [ "network" "pulseaudio" "battery" "clock" ];
      modules = {
        "sway/workspaces" = {
          all-outputs = true;
          disable-scroll = true;

          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
            "7" = [ ];
            "8" = [ ];
            "9" = [ ];
            "10" = [ ];
          };
        };

        "sway/mode" = {
          format = "{}";
        };

        "clock" = {
          format = " {:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };

          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = "ﮣ {capacity}%";
          format-full = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" "" "" "" "" "" "" ];
        };

        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "  {ifname}: {ipaddr}/{cidr}";
          format-linked = "  {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "Signal Strength: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
          on-click-right = "${config.programs.alacritty.package}/bin/alacritty -e ${pkgs.networkmanager}/bin/nmtui";
        };

        "pulseaudio" = {
          on-click = "pactl set-sink-mute 45 toggle";
          format = "{icon} {volume}%";
          format-muted = "婢  Muted";
          format-source = "";
          format-source-muted = "Muted";
          format-icons.default = [ " " " " " " ];
        };
      };
    }];
  };
}
