{

  env = {
    TERM = "xterm-256color";
  };

  #window = {
  #  dynamic_padding = true;
  #  padding = {
  #    x = 8;
  #    y = 8;
  #  };
  #};

  font = {
    normal = {
      family = "Meslo LG M for Powerline";
      style = "Regular";
    };

    bold = {
      family = "Meslo LG M for Powerline";
      style = "Bold";
    };

    italic = {
      family = "Meslo LG M for Powerline";
      style = "Italic";
    };

    size = 11;
  };

  colors = {
    primary = {
      background = "0x1d2021";
      foreground = "0xfbf1c7";
    };

    normal = {
      black = "0x282828";
      red = "0xfb4934";
      green = "0xb8bb26";
      yellow = "0xfabd2f";
      blue = "0x83a598";
      magenta = "0xd3869b";
      cyan = "0x8ec07c";
      white = "0xfbf1c7";
    };

    bright = {
      black = "0x32302f";
      red = "0xea6962";
      green = "0xa9b665";
      yellow = "0xffc745";
      blue = "0x7daea3";
      magenta = "0xd3869b";
      cyan = "0x89b482";
      white = "0xf9f5d7";
    };
  };

  cursor = {
    style = "Block";
  };

}
