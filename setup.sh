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
    rm -rf "$HOME/.vim.bak"
    mv -f "$HOME/.vim" "$HOME/.vim.bak"
fi

# Clone Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Copy has.vim, used by first-time run of vim to avoid loading
# a not-yet-existent colorscheme.
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

# Copy some of Damian Conway's plugins.
VIM_DIR="$HOME/.vim"
DCONWAY_GIT_DIR=/tmp/dconway-vim
if [ -e "${DCONWAY_GIT_DIR}" ]; then
    rm -rf "${DCONWAY_GIT_DIR}"
fi
git clone https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup.git "${DCONWAY_GIT_DIR}"

if [ $? == 0 ]; then
    # Ensure our plugin dir exists
    mkdir -p "${VIM_DIR}/plugin"

    # plugins
    cp "${DCONWAY_GIT_DIR}/plugin/visualguide.vim" "${VIM_DIR}/plugin/"
    cp "${DCONWAY_GIT_DIR}/plugin/yankmatches.vim" "${VIM_DIR}/plugin/"
fi
rm -rf /tmp/dconway-vim

# ==========
# tmux setup
# ==========

# Backup and remove any .tmux directory
if [ -d "$HOME/.tmux" ]; then
    rm -rf "$HOME/.tmux" >/dev/null 2>&1
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

