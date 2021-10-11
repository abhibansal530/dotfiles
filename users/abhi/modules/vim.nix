{ config, lib, pkgs, ... }:

{
  programs.vim = {
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
}
