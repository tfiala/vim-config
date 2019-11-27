" Preliminaries {{{
" Always enable vim additions, vi compatibility unneeded.
set nocompatible

" Ignore extra files.
set nobackup
set nowritebackup
set noswapfile

" We want to use jk as <Esc>
:imap jk <Esc>

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

Plugin 'VundleVim/Vundle.vim'

" General Plugins {{{
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'dbeniamine/todo.txt-vim'
Plugin 'elixir-editors/vim-elixir'
Plugin 'mtth/scratch.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-erlang/vim-dialyzer'
Plugin 'vim-scripts/utl.vim'
Plugin 'vim-voom/VOoM'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'

" }}}

" Clojure-related plugins {{{
Plugin 'guns/vim-clojure-static'
Plugin 'guns/vim-sexp'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-salve'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
Plugin 'venantius/vim-cljfmt'
" }}}

" Haskell-related plugins {{{
Plugin 'neovimhaskell/haskell-vim'
" }}}

" markdown-related plugins {{{
Plugin 'junegunn/vim-xmark'
" }}}

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on
" }}}

" Leader Setup {{{
" Remap the leader key to the space bar
let mapleader=" "
" }}}

" Clipboard Setup {{{
" Use the macOS clipboard by default with yank and paste
set clipboard=unnamed
" }}}

" Search: remap to use normal regular expression content.
" By default, regexes require escaping pretty much every metacharacter.
" This prefixes searching with \v, which puts vim into normal regex
" mode.
noremap / /\v

" Folding {{{

" Function to enable fold "focus" mode.  When in focus mode,
" syntax-oriented folding is used and folds are opened and
" closed automatically.
function FF_FocusFolds()
    " Enable auto-open, auto close of folds when we enter and leave them.
    setlocal foldopen=all
    setlocal foldclose=all
endfunction

" Function to disable fold "focus" mode.  Shuts off
" foldopen/foldclose, and opens all folds.
function FF_UnfocusFolds()
    setlocal foldopen="block,hor,mark,percent,quickfix,search,tag,undo"
    setlocal foldclose=""
    %foldopen!
endfunction

nmap <silent> <expr> zF FF_FocusFolds()
nmap <silent> <expr> zf FF_UnfocusFolds()

" Fold parts that don't match the current search
nmap <silent> <expr>  zz  FS_ToggleFoldAroundSearch({'context':1})

" auto-folding {{{
" Use syntax-directed folding in general.
set foldmethod=syntax

" shell scripts tend to be mostly flat, do explicit marker-based folding
autocmd FileType sh,zsh setlocal foldmethod=marker
" }}}

" Fold Detection/foldcolumn {{{
" Put a guideline on the side to show fold level.
function HandleFoldColumns()
    "Attempt to move between folds, checking line numbers to see if it worked.
    "If it did, there are folds.

    function! HasFoldsInner()
        let origline=line('.')
        :norm zk
        if origline==line('.')
            :norm zj
            if origline==line('.')
                return 0
            else
                return 1
            endif
        else
            return 1
        endif
        return 0
    endfunction

    let l:winview=winsaveview() "save window and cursor position
    let foldsexist=HasFoldsInner()
    if foldsexist
        set foldcolumn=6
    else
        "Move to the end of the current fold and check again in case the
        "cursor was on the sole fold in the file when we checked
        if line('.')!=1
            :norm [z
            :norm k
        else
            :norm ]z
            :norm j
        endif
        let foldsexist=HasFoldsInner()
        if foldsexist
            set foldcolumn=1
        else
            set foldcolumn=0
        endif
    end
    call winrestview(l:winview) "restore window/cursor position
endfunction
au CursorHold,BufWinEnter ?* call HandleFoldColumns()
" }}}
" }}}

" Unhighlight matches with backspace in normal mode
nmap <silent> <BS> :nohlsearch<CR>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :edit $MYVIMRC<CR>
nmap <silent> <leader>sv :source $MYVIMRC<CR>

" Turn on syntax highlighting
filetype on
filetype plugin indent on
syntax on

" various global behavioral settings
set cmdheight=1
set completeopt=menuone,menu,longest
set showcmd		" Show (partial) command in status line.
set showmatch	" Show matching brackets.
set ignorecase	" Do case insensitive matching
set smartcase	" Do smart case matching: case insensitive on all lower, case sensitive otherwise
set incsearch	" Incremental search
set autowrite	" Automatically save before commands like :next and :make
set hidden      " Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes) in terminals
set nowrap      " don't wrap lines
set autoindent  " always turn on autoindenting
set copyindent  " copy the previous indentation on autoindenting
set history=1000
set number      " always show line numbers
set showmode
set smartindent
set smarttab
" This one drives me nuts, particularly in Python, where it is often
" syntatically invalid.
" set tw=80
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git
set wildmenu

" bell settings {{{
" The combination of the following two commands is used to shut off
" the audible bell.  This is somehow important in my setup because
" I get random beeps on startup when I load a file, and after hitting
" Esc.
" This turns on the visual bell and shuts off the beep.
set visualbell
" This then turns off the visual bell.
set t_vb=
" }}}

" handle tabs as spaces
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround  " use multiples of shiftwidth when indenting with '<' and '>'
set smarttab    " insert tobs on start of a line according to shiftwidth, not tabstop

set hlsearch    " highlight search term

" Undo History {{{
" Turn on persistent undo
if has('persistent_undo')
    set undofile
    set undodir=$HOME/.VIM_UNDO_FILES
endif
" }}}

" Insert-mode deletion: allow deleting more than we inserted.
" Otherwise, we get classic vi behavior where we cannot
" delete any more than we inserted since we started insert mode.
" {{{
set backspace=indent,eol,start
" }}}

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

" 80-column warning {{{
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)
" }}}

" always show status line
set laststatus=2

" show whitespace characters
noremap <F8> :set list!<CR>
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:_
" highlight SpecialKey term=standout ctermbg=yellow guibg=yellow

" Set font {{{
if has("gui_running")
  set guifont=Source\ Code\ Pro\ Medium:h14
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
au VimEnter *.{clj,cljs,edn,lisp} RainbowParenthesesToggle
au Syntax *.{clj,cljs,edn,lisp} RainbowParenthesesLoadRound
au Syntax *.{clj,cljs,edn,lisp} RainbowParenthesesLoadSquare
au Syntax *.{clj,cljs,edn,lisp} RainbowParenthesesLoadBraces
" }}}
" }}}

" Syntastic Setup {{{
" Recommended initial settings {{{
" These come straight from the github page
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
map <Leader>s :SyntasticToggleMode<CR>

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


" vim-notes setup
" {{{
let g:notes_directories = ['~/notes/home-notes', '~/Dropbox/shared-notes']
" }}}

" utl setup
" {{{
    " setup the web browser
	let g:utl_cfg_hdl_scm_http_system = "silent !open -a Safari '%u'"
" }}}

" NERD Tree Configuration
" {{{
silent! nmap <C-p> :NERDTreeToggle<CR>
silent! map <F2> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>
let g:NERDTreeToggle="<F2>"
let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"
" }}}

" Setup arrows as shortcuts for vimgrep/helpgrep-style c-results
" {{{
nmap <silent> <RIGHT>         :cnext<CR>
nmap <silent> <RIGHT><RIGHT>  :cnfile<CR>
nmap <silent> <LEFT>          :cprev<CR>
nmap <silent> <LEFT><LEFT>    :cpfile<CR>
" }}}

" Ensure help files get the full window in their own tab
" {{{
augroup HelpInTabs
    autocmd!
    autocmd BufEnter *.txt  call HelpInNewTab()
augroup END

function! HelpInNewTab ()
    if &buftype == 'help'
        " Convert the help window to a tab...
        execute "normal \<C-W>T"
    endif
endfunction
" }}}

" CtrlP configuration {{{
" JVM-style build output {{{
set wildignore+=*/target/*
" }}}
" Version control {{{
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
" Don't limit max number of files - mainly for LLDB with embedded LLVM tree
let g:ctrlp_max_files = 0
" }}}
" LLDB ignore paths {{{
set wildignore+=*/build/*
" }}}
" }}}


" Adjust open/close delimiter hopping (%)
" {{{
set matchpairs+=<:>,=:;
" }}}

" clang-related settings {{{
map <C-K> :pyf /Users/tfiala/clang/latest/share/clang/clang-format.py<cr>
imap <C-K> <c-o>:pyf /Users/tfiala/clang/latest/share/clang/clang-format.py<cr>
let g:syntastic_cpp_checkers = [ 'clang_check', 'clang_tidy' ]
let g:syntastic_cpp_clang_tidy_post_args = ""
" }}}

" Spell checking {{{
set spell spelllang=en_us
" }}}

" markdown support {{{
au! BufRead,BufNewFile *.markdown set filetype=markdown
au! BufRead,BufNewFile *.md       set filetype=markdown
" }}}
