{
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

  "clock" = {
    format = " {:%H:%M}";
    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    format-alt = "{:%Y-%m-%d}";
  };

  "battery" = {
    states = {
      warning = 30;
      critical = 15;
    };

    format = "{icon}  {capacity}%";
    format-charging = "{icon}  {capacity}%";
    format-plugged = "{icon}  {capacity}%";
    format-full = "{icon}  {capacity}%";
    format-icons = [ "" "" "" "" "" ];
  };

  "network" = {
    format-wifi = "  {essid}";
    format-ethernet = "󰤮 Disconnected";
    format-linked = "{ifname} (No IP) ";
    format-disconnected = "󰤮 Disconnected";
    tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
  };

  "pulseaudio" = {
    on-click = "pactl set-sink-mute 45 toggle";
    format = "{icon} {volume}%";
    format-muted = "婢  Muted";
    format-source = "";
    format-source-muted = "Muted";
    format-icons.default = [ " " " " " " ];
  };
}
