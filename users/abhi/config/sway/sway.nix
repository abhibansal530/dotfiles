{ pkgs }:

#let
#  colorscheme = import ./colors.nix;

rec {

  # colors = {
  #   focused = {
  #     border = "#${colorscheme.}";
  #     background = "#${colorscheme.}";
  #     text = "#${colorscheme.}";
  #     indicator = "#${colorscheme.}";
  #     childBorder = "#${colorscheme.}";
  #   };
  #   focusedInactive = {
  #   };
  #   unfocused = {
  #   };
  # };

  left = "h";
  down = "j";
  up = "k";
  right = "l";

  modifier = "Mod4";
  terminal = "alacritty";

  bars = [{
    command = "${pkgs.waybar}/bin/waybar";
  }];

  input = {
    "type:touchpad" = {
      tap = "enabled";
      dwt = "enabled";
      tap_button_map = "lrm";
      natural_scroll = "enabled";
    };
  };

  #menu = "${pkgs.wofi}/bin/wofi --show=run --hide-scroll | xargs swaymsg exec --";
  menu = "rofi -modi drun -show drun -matching fuzzy";

  fonts = {
    names = [ "SauceCodePro Nerd Font" ];
    style = "Regular";
  };

  output = {
    "*".bg = ''/home/abhi/Pictures/WallPapers/wallpaper.png fill'';
    "HDMI-A-1" = {
      mode = "1920x1080@144.013Hz";
      scale = "1.1";
      subpixel = "rgb";
      adaptive_sync = "on";
    };
  };

  assigns = {
    "1" = [{ app_id = "firefox"; }];
    "5" = [{ app_id = "emacs"; }];
  };

  startup = [
    { command = "${pkgs.mako}/bin/mako"; }
  ];

  keybindings = 
    let
      mod = modifier;
      inherit left down up right menu;
    in
    {
      "${mod}+Return" = "exec ${terminal}";
      "${mod}+Shift+q" = "kill";
      "${mod}+d" = "exec ${menu}";

      "${mod}+${left}" = "focus left";
      "${mod}+${down}" = "focus down";
      "${mod}+${up}" = "focus up";
      "${mod}+${right}" = "focus right";

      "${mod}+Left" = "focus left";
      "${mod}+Down" = "focus down";
      "${mod}+Up" = "focus up";
      "${mod}+Right" = "focus right";

      "${mod}+Shift+${left}" = "move left";
      "${mod}+Shift+${down}" = "move down";
      "${mod}+Shift+${up}" = "move up";
      "${mod}+Shift+${right}" = "move right";

      "${mod}+Shift+Left" = "move left";
      "${mod}+Shift+Down" = "move down";
      "${mod}+Shift+Up" = "move up";
      "${mod}+Shift+Right" = "move right";

      "${mod}+Shift+f" = "floating toggle";

      # Swap focus between the tiling area and focus area.
      "${mod}+Shift+g" = "focus mode_toggle";

      "${mod}+Shift+c" = "reload";
      "${mod}+Shift+r" = "restart";
      "${mod}+Shift+e" = "exec swaynag -t warning -m 'Do you really want to exit sway?' -b 'Yes, exit way' 'swaymsg exit'";

      "${mod}+r" = "mode resize";
      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout tabbed";
      "${mod}+t" = "layout toggle split";
      "${mod}+f" = "fullscreen toggle";
      "${mod}+b" = "split h";
      "${mod}+v" = "split v";

      # Lock screen.
      "${mod}+z" = ''exec ${pkgs.swaylock}/bin/swaylock -i :/home/abhi/Pictures/WallPapers/lock.png'';

      # Dismiss mako notifications.
      "${mod}+x" = "exec ${pkgs.mako}/bin/makoctl dismiss";
      "${mod}+Shift+x" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

      # Workspaces
      "${mod}+1" = "workspace number 1";      
      "${mod}+2" = "workspace number 2";
      "${mod}+3" = "workspace number 3";
      "${mod}+4" = "workspace number 4";
      "${mod}+5" = "workspace number 5";
      "${mod}+6" = "workspace number 6";
      "${mod}+7" = "workspace number 7";
      "${mod}+8" = "workspace number 8";
      "${mod}+9" = "workspace number 9";
      "${mod}+0" = "workspace number 10";
      "${mod}+Tab" = "workspace back_and_forth";

      "${mod}+Shift+1" = "move container to workspace number 1";
      "${mod}+Shift+2" = "move container to workspace number 2";
      "${mod}+Shift+3" = "move container to workspace number 3";
      "${mod}+Shift+4" = "move container to workspace number 4";
      "${mod}+Shift+5" = "move container to workspace number 5";
      "${mod}+Shift+6" = "move container to workspace number 6";
      "${mod}+Shift+7" = "move container to workspace number 7";
      "${mod}+Shift+8" = "move container to workspace number 8";
      "${mod}+Shift+9" = "move container to workspace number 9";
      "${mod}+Shift+0" = "move container to workspace number 10";

      # Scratchpad:
      # Sway has a "scratchpad", which is a bag of holding for windows.
      # You can send windows there and get them back later.

      # Move the currently focused window to the scratchpad
      "${mod}+Shift+minus" = "move container to scratchpad";

      # Show the next scratchpad window or hide the focused scratchpad window.
      # If there are multiple scratchpad windows, this command cycles through them.
      "${mod}+minus" = "scratchpad show";

      # Brightness.
      "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -q set +5%";
      "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -q set 5%-";
      "XF86KbdBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl --device='asus::kbd_backlight' set 3";
      "XF86KbdBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl --device='asus::kbd_backlight' set 0";

      # Volume.
      "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioRaiseVolume" =
        "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" =
        "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";

      # Commands to open/switch to the app.
      "${mod}+e" = "exec sway-focus-or-open emacs emacs";
      "${mod}+F1" = "exec sway-focus-or-open firefox firefox";

      # TODO : Screenshot.
    };

  modes = {
    resize = {
      Left = "resize shrink width 10 px or 10 ppt";
      Down = "resize grow height 10 px or 10 ppt";
      Up = "resize shrink height 10 px or 10 ppt";
      Right = "resize grow width 10 px or 10 ppt";
      Return = "mode default";
      Escape = "mode default";
    };
  };
}