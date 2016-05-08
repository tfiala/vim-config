#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# =========
# VIM setup
# =========

# Backup and remove any existing .vimrc
if [ -f "$HOME/.vimrc" ]; then
    cp "$HOME/.vimrc" "$HOME/.vimrc.bak"
    rm "$HOME/.vimrc"
fi

# Backup and remove any existing .vim directory
if [ -d "$HOME/.vim" ]; then
    mv -f "$HOME/.vim" "$HOME/.vim.bak/"
fi

# Clone Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Copy has.vim, used by first-time run of vim to avoid loading
# a not-yet-existant colorscheme.
mkdir -p "$HOME/.vim/autoload"
cp -f "$SCRIPT_DIR/has.vim" "$HOME/.vim/autoload/"

# Create symbolic link from $HOME/.vimrc to the .vimrc in this dir.
ln -s "$SCRIPT_DIR/vimrc" "$HOME/.vimrc"

# Install the Powerline fonts if they don't exist.
POWERLINE_SRC_DIR="$HOME/src/powerline-fonts"
if [ ! -d "$POWERLINE_SRC_DIR" ]; then
    mkdir -p "$HOME/src"
    pushd "$HOME/src"
    git clone https://github.com/powerline/fonts.git powerline-fonts
    cd fonts
    ./install.sh
    popd
fi

# Install Vundle plugins
vim +VundleInstall +qall

# Make vimproc.vim
VIMPROC_DIR="$HOME/.vim/bundle/vimproc.vim"
if [ -d "$VIMPROC_DIR" ]; then
    pushd "$VIMPROC_DIR"
    make
    popd
fi

# Haskell setup.
VIM_DIR="$HOME/.vim"
# - grab haskell.vim and cabal.vim
git clone https://github.com/sdiehl/haskell-vim-proto /tmp/haskell-vim-proto
if [ $? == 0 ]; then
    mkdir -p "$VIM_DIR/syntax"
    cp /tmp/haskell-vim-proto/vim/syntax/haskell.vim /tmp/haskell-vim-proto/vim/syntax/cabal.vim "$VIM_DIR/syntax/"

    mkdir -p "$VIM_DIR/snippets"
    cp /tmp/haskell-vim-proto/vim/snippets/haskell.snippets "$VIM_DIR/snippets/"
fi
rm -rf /tmp/haskell-vim-proto

# ==========
# tmux setup
# ==========

# Backup and remove any .tmux directory
if [ -d "$HOME/.tmux" ]; then
    mv -f "$HOME/.tmux" "$HOME/.tmux.bak/"
fi

# Install the tmux plugin manager
mkdir -p "$HOME/.tmux/plugins"
git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# Setup the .tmux.conf link
if [ -f "$HOME/.tmux.conf" ]; then
    cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
    rm "$HOME/.tmux.conf"
fi

# link ~/.tmux.conf to our repo one.
ln -s "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"

