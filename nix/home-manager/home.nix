{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "abhi";
  home.homeDirectory = "/home/abhi";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  fonts.fontconfig.enable = true;

  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "Iosevka" "SourceCodePro" ]; })
    (pkgs.powerline-fonts)
    (pkgs.ripgrep)
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = import ./config/alacritty.nix;
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
        st = "status";
      };
      userName = "Abhishek Bansal";
      userEmail = "abhibansal530@gmail.com";
    };

    waybar = {
      enable = true;
      settings = [{
        layer = "bottom";
        position = "bottom";
        height = 15;
        modules-left = [ "sway/workspaces" ];
        modules-right = [ "network" "pulseaudio" "battery" "clock" ];
        modules = import ./config/waybar/modules.nix;
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

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      initExtra = ''
        if [[ $(tty) = /dev/tty1 ]]; then
          export XDG_SESSION_TYPE="wayland" # otherwise set to tty
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
      };
      randr = {
        screen = 0;
      };
    };
    temperature = {
      day = 4100;
      night = 3500;
    };
  };

}