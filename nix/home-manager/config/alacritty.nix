{

  env = {
    TERM = "xterm-256color";
  };

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

    size = 12;
    use_thin_strokes = false;
  };

  draw_bold_text_with_bright_colors = true;

  colors = {
    primary = {
      background = "0x272727";
      foreground = "0xebdbb2";
    };

    normal = {
      black = "0x272727";
      red = "0xcc231c";
      green = "0x989719";
      yellow = "0xd79920";
      blue = "0x448488";
      magenta = "0xb16185";
      cyan = "0x689d69";
      white = "0xa89983";
    };

    bright = {
      black = "0x928373";
      red = "0xfb4833";
      green = "0xb8ba25";
      yellow = "0xfabc2e";
      blue = "0x83a597";
      magenta = "0xd3859a";
      cyan = "0x8ec07b";
      white = "0xebdbb2";
    };

    cursor = {
      text = "0x272727";
      cursor = "0xebdbb2";
    };

    selection = {
      text = "0x655b53";
      background = "0xebdbb2";
    };
  };

  cursor = {
    style = "Block";
  };

}
