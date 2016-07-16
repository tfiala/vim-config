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

Plugin 'VundleVim/Vundle.vim'

" General Plugins {{{
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'freitass/todo.txt-vim'
Plugin 'mtth/scratch.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/utl.vim'
Plugin 'vim-voom/VOoM'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'
" }}}

" Clojure-related plugins {{{
Plugin 'guns/vim-clojure-static'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'kovisoft/paredit'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
" }}}

" Haskell-related plugins {{{
Plugin 'eagletmt/ghcmod-vim'
Plugin 'eagletmt/neco-ghc'
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'garbas/vim-snipmate'
Plugin 'godlygeek/tabular'
Plugin 'ervandew/supertab'
" }}}

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on
" }}}

" Leader Setup {{{
" Remap the leader key to the space bar
let mapleader=" "
" }}}

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :edit $MYVIMRC<CR>
nmap <silent> <leader>sv :source $MYVIMRC<CR>

" Turn on syntax highlighting
filetype on
filetype plugin indent on
syntax on

" various global behavioral settings
set clipboard=unnamedplus,autoselect
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

" handle tabs as spaces
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround  " use multiples of shiftwidth when indenting with '<' and '>'
set smarttab    " insert tobs on start of a line according to shiftwidth, not tabstop

set hlsearch    " highlight search term

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
" Perl Setup {{{
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'perlcritic', 'podchecker']
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

" Configure NeoComplete
" {{{
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}

" Supertab  {{{
let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

" Haskell-specific {{{
let g:haskellmode_completion_ghc = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" }}}
" }}}

" Tabularize settings {{{
vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>
" }}}

" Haskell settings {{{
autocmd FileType haskell,cabal setlocal softtabstop=2 shiftwidth=2 
set wildignore+=.cabal-sandbox
let g:haskell_tabular = 1

" ghc-mod settings {{{
map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>
" }}}
" }}}

" clang-related settings {{{
map <C-K> :pyf /Users/tfiala/clang/latest/share/clang/clang-format.py<cr>
imap <C-K> <c-o>:pyf /Users/tfiala/clang/latest/share/clang/clang-format.py<cr>
let g:syntastic_cpp_checkers = [ 'clang_check', 'clang_tidy' ]
let g:syntastic_cpp_clang_tidy_post_args = ""
" }}}
