''
  * {
      border-radius: 0;
      font-family: Liga SFMono Nerd Font;
      padding-bottom: 1px;
      padding-top: 1px;
      font-size: 11px;
      min-height: 0;
  
      /* border: 10px solid transparent;
      border-image: url(~/.config/sway/borders/dropShadowDarkOffset2.png) 30 stretch; */
  }
  
  window#waybar {
      padding: 15px;
      background: transparent;
      color: white;
  }
  
  tooltip {
  	background: #2E3440;
  	border-radius: 15px;
  	border-width: 2px;
  	border-style: solid;
  	border-color: #2E3440;
  	}
  
  #workspaces button {
      padding: 5px 10px;
      color: #D8DEE9;
  }
  
  #workspaces button.focused {
      box-shadow: 2px 2px 6px 1px black;
      color: #2E3440;
      background-color: #8FBCBB;
      border-radius: 15px;
  }
  
  #workspaces button.urgent {
      color: #2E3440;
      background-color: #BF616A;
      border-radius: 15px;
  }
  
  #workspaces button:hover {
  	background-color: #5cEfFF;
  	color: #2E3440;
  	border-radius: 15px;
  }
  
  #clock, #battery, #pulseaudio, #network, #workspaces {
  	background-color: #2E3440;
  	padding: 5px 10px;
  	margin: 5px 0px;
  }
  
  #workspaces {
  	background-color: #2E3440;
  	border-radius: 15px 0px 0px 15px;
  }
  
  #clock {
      color: #EBCB8B;
      border-radius: 0px 15px 15px 0px;
      margin-right: 10px;
  }
  
  #battery {
      color: #A3BE8C;
  }
  
  #battery.charging {
      color: #D08770;
  }
  
  #battery.warning:not(.charging) {
      background-color: #2E3440;
      color: #BF616A;
  }
  
  #network {
  	color: #B48EAD;
  	border-radius: 0px 0px 0px 0px;
  }
  
  #pulseaudio {
  	color: #81a1c1;
  }
''
