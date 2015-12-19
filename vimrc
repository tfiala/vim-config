" Preliminaries {{{
" Always enable vim additions, vi compatibility unneeded.
set nocompatible

" Ignore extra files.
set nobackup
set nowritebackup
set noswapfile

" Ensure we re-read the file if its in the buffer and has been modified
" outside of vim.
set autoread

" Disable long message in startup screen.
set shortmess+=I
" }}}
" Vundle setup {{{
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" General Plugins {{{
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'
Plugin 'wincent/command-t'
" }}}

" Clojure-related plugins {{{
Plugin 'guns/vim-clojure-static'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
" }}}

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on
" }}}

" Leader Setup {{{
" Remap the leader key from '\' to ','
let mapleader=","
" }}}

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :edit $MYVIMRC<CR>
nmap <silent> <leader>sv :source $MYVIMRC<CR>

" Turn on syntax highlighting
filetype on
filetype plugin indent on
syntax on

" various global behavioral settings
set showcmd		" Show (partial) command in status line.
set showmatch	" Show matching brackets.
set ignorecase	" Do case insensitive matching
set smartcase	" Do smart case matching: case insensitive on all lower, case sensitive otherwise
set incsearch	" Incremental search
set autowrite	" Automatically save before commands like :next and :make
set hidden      " Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes) in terminals
set nowrap      " don't wrap lines
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent  " always turn on autoindenting
set copyindent  " copy the previous indentation on autoindenting
set number      " always show line numbers

" handle tabs as spaces
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround  " use multiples of shiftwidth when indenting with '<' and '>'
set smarttab    " insert tobs on start of a line according to shiftwidth, not tabstop

set hlsearch    " highlight search term


" Use "indent" program for code indenting.
set equalprg=indent

" NETRW SSH settings
let g:netrw_silent = 1

" XML formatting support
" TODO: modify to handle only the selected region
map <F2> <Esc>:%!xmllint --format -<CR>

" Visual-related {{{
if !has("gui_running")
  " Enable 256-color mode
  set t_Co=256
endif

" Color Scheme {{{
" setup the colorscheme
if has#colorscheme('solarized')
    let solarizedScheme=$SOLARIZED
    if solarizedScheme == 'light'
        set background=light
    else
        set background=dark
    endif
    colorscheme solarized
endif
" }}}

" always show status line
set laststatus=2

" show whitespace characters
noremap <F8> :set list!<CR>
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:_
" highlight SpecialKey term=standout ctermbg=yellow guibg=yellow

" Set font {{{
if has("gui_running")
  set guifont=Source\ Code\ Pro\ for\ Powerline:h14'
endif

" Setup powerline font dictionary.
let g:airline_powerline_fonts = 1
" }}}

" }}}

" Rainbow Parentheses Config {{{
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

" Use rainbow parens for lispen {{{
au VimEnter *.{clj,edn,lisp} RainbowParenthesesToggle
au Syntax *.{clj,edn,lisp} RainbowParenthesesLoadRound
au Syntax *.{clj,edn,lisp} RainbowParenthesesLoadSquare
au Syntax *.{clj,edn,lisp} RainbowParenthesesLoadBraces
" }}}
" }}}

" Syntastic Setup {{{
" Recommended initial settings {{{
" These come straight from the github page
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" }}}
" Objective-C Setup {{{
let g:syntastic_objc_checkers = ['oclint', 'gcc']
" }}}
" Objective-C++ Setup {{{
let g:syntastic_objcpp_checkers = ['oclint', 'gcc']
" }}}
" }}}

" command-t setup {{{
let g:CommandTFileScanner = 'git'
" }}}

" PerlTidy Setup {{{
"define :Tidy command to run perltidy on visual selection || entire buffer"
command -range=% -nargs=* Tidy <line1>,<line2>!perltidy

"run :Tidy on entire buffer and return cursor to (approximate) original position"
fun DoTidy()
    let l = line(".")
    let c = col(".")
    :Tidy
    call cursor(l, c)
endfun

"shortcut for normal mode to run on entire buffer then return to current line"
au Filetype perl nmap <F2> :call DoTidy()<CR>

"shortcut for visual mode to run on the the current visual selection"
au Filetype perl vmap <F2> :Tidy<CR>
" }}}
