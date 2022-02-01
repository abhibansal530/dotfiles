{ config, pkgs }:

#let
#  colorscheme = import ./colors.nix;

let
  userName = config._my.user.name;
  browser = config._my.default-browser;
  browserAppId =  (import ./app_ids.nix).${browser};
  browserCfg = config.home-manager.users.${userName}.programs.${browser};
  emacs = config.home-manager.users.${userName}.programs.emacs;
in
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

  menu = "rofi -modi drun -show drun -matching fuzzy";

  fonts = {
    names = [ "SauceCodePro Nerd Font" ];
    style = "Regular";
  };

  output = {
    "*".bg = ''~/Pictures/WallPapers/wallpaper.png fill'';
    "HDMI-A-1" = {
      mode = "1920x1080@144.013Hz";
      scale = "1.2";
      subpixel = "rgb";
      adaptive_sync = "on";
    };
  };

  assigns = {
    "1" = [{ app_id = browserAppId; }];
    "5" = [{ app_id = "emacs"; }];
  };

  startup = [
    { command = "${pkgs.mako}/bin/mako"; }
    { command = "${pkgs.keepassxc}/bin/keepassxc"; }
    { command = "${browserCfg.package}/bin/${browser}"; }
    { command = "${emacs.package}/bin/emacs"; }
    # Store clipboard entries in clipman (to query with rofi later).
    { command = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch my-clipman"; }
    { command = "sway-auto-rename -l /tmp/sway_auto_rename.log" ; always = true; }
    {
      command =
        let lockCmd = "${pkgs.swaylock}/bin/swaylock -f -i :~/Pictures/WallPapers/lock.png";
        in
        ''
        ${pkgs.swayidle}/bin/swayidle -w \
        timeout 300 '${lockCmd}' \
        timeout 500 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
        before-sleep '${lockCmd}'
        '';
    }
    { command = "sway-clamshell-helper" ; always = true; }
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
      "${mod}+Shift+p" = ''mode "system:  [r]eboot  [p]oweroff  [l]ogout"'';
      "${mod}+Shift+e" = "exec swaynag -t warning -m 'Do you really want to exit sway?' -b 'Yes, exit way' 'swaymsg exit'";

      "${mod}+r" = "mode resize";
      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout tabbed";
      "${mod}+t" = "layout toggle split";
      "${mod}+f" = "fullscreen toggle";
      "${mod}+b" = "split h";
      "${mod}+v" = "split v";

      # Lock screen.
      "${mod}+z" = ''exec ${pkgs.swaylock}/bin/swaylock -i :~/Pictures/WallPapers/lock.png'';

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
      # Ref. : https://www.reddit.com/r/swaywm/comments/fk08lu/nicer_brightness_control/
      "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -q set $(${pkgs.brightnessctl}/bin/brightnessctl get | awk '{ print $1 * 1.4 }')";
      "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -q set $(${pkgs.brightnessctl}/bin/brightnessctl get | awk '{ print $1 / 1.4 }')";
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
      "${mod}+F1" = "exec sway-focus-or-open ${browserAppId} ${browser}";
      "${mod}+p" = "[app_id = \"org.keepassxc.KeePassXC\"] scratchpad show";

      # Select a clipboard entry using rofi.
      "${mod}+Space" = "exec ${pkgs.clipman}/bin/clipman pick -t rofi";

      # Screenshot utils.
      ## Screenshot active display (output).
      ## TODO : Pass --locked argument to bindsym.
      "Print" = "exec grimshot --notify save output - | swappy -f -";

      ## Screenshot active window.
      "${mod}+Print" = "exec grimshot --notify save active - | swappy -f -";

      ## Screenshot selected region.
      "${mod}+Shift+Print" = "exec grimshot --notify save area - | swappy -f -";
    };

  modes = {
    "system:  [r]eboot  [p]oweroff  [l]ogout" = {
      r = "exec reboot";
      p = "exec poweroff";
      l = "exit";
      Return = "mode default";
      Escape = "mode default";
    };

    resize = {
      Left = "resize shrink width 10 px or 10 ppt";
      Down = "resize grow height 10 px or 10 ppt";
      Up = "resize shrink height 10 px or 10 ppt";
      Right = "resize grow width 10 px or 10 ppt";
      Return = "mode default";
      Escape = "mode default";
    };
  };

  floating.criteria = [
    { app_id = "org.keepassxc.KeePassXC"; }
    { app_id = "zoom"; }
    { app_id = "zoom"; title = "Choose ONE of the audio conference options"; }
    { app_id = "zoom"; title = "zoom"; }
  ];

  window.commands = [
    {
      command = "move to scratchpad";
      criteria = {
        app_id = "org.keepassxc.KeePassXC";
      };
    }

    {
      command = "floating disable";
      criteria = {
        app_id = "zoom";
        title = "Zoom Meeting";
      };
    }
    {
      command = "floating disable";
      criteria = {
        app_id = "zoom";
        title = "Zoom - Free Account";
      };
    }
  ];
}
