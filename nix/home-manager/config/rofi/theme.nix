{config}:

let
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  "*" = {
    background = mkLiteral "#1D2021";
    background-alt = mkLiteral "#282828";
    foreground = mkLiteral "#FBF1C7";
    accent = mkLiteral "#7DAEA3";
    text-color = mkLiteral "@fg";
  };

  "#inputbar" = {
    expand = false;
    children = map mkLiteral [ "prompt" "entry" ];
    background-color = mkLiteral "@background-alt";
    text-color = mkLiteral "@background";
    border = mkLiteral "0% 0% 0% 0%";
    border-color = mkLiteral "@accent";
    #border-radius = mkLiteral "10px";
    margin = mkLiteral "0% 0% 0% 0%";
    padding = mkLiteral "1%";
  };

  "#prompt" = {
    background-color = mkLiteral "@background-alt";
    text-color = mkLiteral "@foreground";
    font = "SauceCodePro Nerd Font 12";
  };

  "#entry" = {
    expand = true;
    background-color = mkLiteral "@background-alt";
    text-color = mkLiteral "@foreground";
    placeholder-color = mkLiteral "@foreground";
  };

  "#element" = {
    background-color = mkLiteral "@background";
    text-color = mkLiteral "@foreground";
    #orientation = mkLiteral "vertical";
    #border-radius = mkLiteral "0%";
    #padding = mkLiteral "2% 0% 2% 0%";
  };

  "#element-icon, element-text" = {
    background-color = mkLiteral "inherit";
    text-color = mkLiteral "inherit";
  };

  #"#element-icon" = {
  #  horizontal-align = mkLiteral "0.5";
  #  vertical-align = mkLiteral "0.5";
  #  size = mkLiteral "48px";
  #  border = mkLiteral "0px";
  #};

  #"#element-text" = {
  #  expand = true;
  #  #horizontal-align = mkLiteral "0.5";
  #  #vertical-align = mkLiteral "0.5";
  #  #margin = mkLiteral "0.5% 0.5% -0.5% 0.5%";
  #};

  "#element selected" = {
    background-color = mkLiteral "@accent";
    text-color = mkLiteral "@background";
    #border-radius = mkLiteral "10px";
  };
}
