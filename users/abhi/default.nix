{ config, inputs, lib, pkgs, ... }:
let
  sway-focus-or-open = import ./config/sway/scripts/focus_or_open.nix { inherit pkgs; };
in
{
  fonts.fontconfig.enable = true;

  home = {
    username = "abhi";
    homeDirectory = "/home/abhi";

    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATOIN = 1;
      _JAVA_AWT_WM_NONREPARENTING = 1;
      MOZ_ENABLE_WAYLAND = 1;
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
    };

    packages = [
      (pkgs.nerdfonts.override { fonts = [ "Iosevka" "SourceCodePro" ]; })
      (pkgs.powerline-fonts)
      (pkgs.ripgrep)
      (pkgs.clang)
      (pkgs.fd)
      (pkgs.sqlite) # For org-roam
      (pkgs.nur.repos.kira-bruneau.rofi-wayland)
      (pkgs.keepassxc)

      # Custom scripts
      sway-focus-or-open
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.05";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    alacritty = {
      enable = true;
      settings = import ./config/alacritty.nix;
    };

    emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
    };

    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        forceWayland = true;
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      aliases = {
        co = "checkout";
        cp = "cherry-pick";
        sh = "show";
        st = "status";
      };
      userName = "Abhishek Bansal";
      userEmail = "abhibansal530@gmail.com";
    };

    mako = {
      enable = true;
      font = "SauceCodePro Nerd Font";
      backgroundColor = "#282828";
      textColor = "#FBF1C7";
      borderColor = "#4C7899";
      layer = "overlay"; # To show over fullscreen apps
    };

    rofi = {
      enable = true;
      package = pkgs.nur.repos.kira-bruneau.rofi-wayland;
      font = "SauceCodePro Nerd Font 12";
      terminal = "alacritty";
      extraConfig = {
        modi = "combi,drun,run";
        sidebar-mode = true;
        combi-mode = "drun,run";
      };
      theme = "${pkgs.nur.repos.kira-bruneau.rofi-wayland}/share/rofi/themes/Arc-Dark";
      #theme = import ./config/rofi/theme.nix { inherit config; };
      #extraConfig = import ./config/rofi/rofi.nix;
    };

    waybar = {
      enable = true;
      settings = [{
        layer = "bottom";
        position = "bottom";
        height = 15;
        modules-left = [ "sway/workspaces" ];
        modules-right = [ "network" "pulseaudio" "battery" "clock" ];
        modules = import ./config/waybar/modules.nix { inherit config pkgs; };
      }];

      style = import ./config/waybar/style.nix;
    };

    tmux = {
      enable = true;
      shell = "\${pkgs.zsh}/bin/zsh";
      terminal = "xterm-256color";
    };

    vim = {
      enable = true;
      plugins = [
        pkgs.vimPlugins.gruvbox-community
        pkgs.vimPlugins.vim-nix
        pkgs.vimPlugins.vim-surround
      ];
      extraConfig = ''
        set autoindent
        set backspace=indent,eol,start
        set colorcolumn=80
        set encoding=utf-8
        set hlsearch
        set incsearch
        set lazyredraw
        set modelines=2
        set nocompatible
        set noswapfile
        set number
        set showmatch
        set textwidth=80
        set t_Co=256
        set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.pyc,node_modules/*
        set wildmenu
        set ttyfast

        colorscheme gruvbox
        set background=dark

        " Gruvbox has 'hard', 'medium' (default) and 'soft' contrast options.
        let g:gruvbox_contrast_light='hard'

        " This needs to come last, otherwise the colors aren't correct.
        syntax on

        " Key Mappings

        " Avoid a shift press.
        nnoremap ; :
        vnoremap ; :

        " Escape is far.
        inoremap jk <ESC>

        " Seamlessly treat visual lines as actual lines when moving around.
        noremap j gj
        noremap k gk
        noremap <Down> gj
        noremap <Up> gk
        inoremap <Down> <C-o>gj
        inoremap <Up> <C-o>gk

        " Use tab and shift-tab to cycle through windows.
        nnoremap <Tab> <C-W>w
        nnoremap <S-Tab> <C-W>W

        let mapleader = ","

        " Clear search highlights.
        nnoremap <silent> <leader><Space> :nohlsearch<cr><C-L>
      '';
    };

    zathura = {
      enable = true;
      options.selection-clipboard = "clipboard";
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      initExtra = ''
        if [[ $(tty) = /dev/tty1 ]]; then
          export XDG_SESSION_TYPE="wayland" # otherwise set to tty
          export QT_QPA_PLATFORM=wayland
          export GDK_BACKEND=wayland
          export SDL_VIDEODRIVER=wayland
          export QT_WAYLAND_DISABLE_WINDOWDECORATOIN="1"
          export _JAVA_AWT_WM_NONREPARENTING=1
          export MOZ_ENABLE_WAYLAND=1
          export CLUTTER_BACKEND=wayland
          export XDG_CURRENT_DESKTOP=sway
          exec sway
        fi

        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=25

        export EDITOR='vim'

        # Use Rg for file searcing in fzf
        export FZF_DEFAULT_COMMAND="${pkgs.ripgrep}/bin/rg --files --hidden --follow"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

        # Key bindings
        bindkey '^ ' autosuggest-accept
      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
        theme = "agnoster";
      };

      shellAliases = {
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = import ./config/sway/sway.nix { inherit pkgs; };
    extraConfig = import ./config/sway/sway_extra.nix { inherit pkgs; };
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = "29.96";
    longitude = "74.71";
    settings = {
      general = {
        adjustment-method = "wayland";
        brightness-day = 0.9;
        brightness-night = 1.0;
        gamma = "0.85:0.8:0.75";
      };
      randr = {
        screen = 0;
      };
    };
    temperature = {
      day = 3300;
      night = 3200;
    };
  };

}
