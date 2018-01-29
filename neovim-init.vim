set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" setup Python 2 support {{{
" let g:loaded_python_provider=0
let g:python_host_prog='/usr/bin/python'
" }}}
" setup Python 3 support {{{
let g:python3_host_prog='/usr/local/bin/python3'
" }}}
