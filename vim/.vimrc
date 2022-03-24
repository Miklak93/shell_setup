"==============================================================================
"                                   SET PART
"==============================================================================
" Use VIM settings instead of VI settings
set nocompatible

" Show line numbers
set number

" Before running plugis add them to the runtime path
set rtp+=~/.vim/bundle/Vundle.vim

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Options needed during files comparison via vim
set diffopt=filler,context:64,iwhite

" Do not keep a backup file
set nobackup

" Keep 50 lines of command line history
set history=50

" Display (partial) command in the last line of the screen
set showcmd

" Display matching words in search mode when the pattern is typing
set incsearch

"Always use autoindenting on
set autoindent

" Higlight editing line
set cursorline

" Transform existing tabs into four spaces
set tabstop=4

" Indents will have 4 chars space
set shiftwidth=4

" Transform tab key into four spaces
set expandtab

" Set a margin
set colorcolumn=80

"==============================================================================
"                                   MAP PART
"==============================================================================
" Don't use Ex mode, use Q for formatting
map Q gq

" Allow to paste multiple times
xnoremap p pgvy

"==============================================================================
"                                   GUI PART
"==============================================================================
"Vundle plugin
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'altercation/vim-colors-solarized'
call vundle#end()

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

set t_Co=256
set background=dark
set guifont=Terminus\ 13
colorscheme solarized
let g:solarized_termcolors=256
let g:solarized_termtrans=1

"==============================================================================
"                               EDITOR SETTINGS
"==============================================================================
" Enable file type detection.
filetype plugin indent on
filetype on
syntax on

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Use thick cursor when INSERT mode is enabled
if has("autocmd")
    au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
    au InsertEnter,InsertChange *
        \ if v:insertmode == 'i' |
            \   silent execute '!echo -ne "\e[6 q"' | redraw! |
        \ elseif v:insertmode == 'r' |
            \   silent execute '!echo -ne "\e[4 q"' | redraw! |
        \ endif
    au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif
