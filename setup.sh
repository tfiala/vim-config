#!/bin/bash

# directory vars {{{
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VIM_DIR="$HOME/.vim"
VIM_DIR_BACKUP="${VIM_DIR}.bak"
VIMRC="$HOME/.vimrc"
VIMRC_BACKUP="${VIMRC}.bak"
NVIM_DIR="$HOME/.config/nvim"
NVIM_INIT="$NVIM_DIR/init.vim"
NVIM_INIT_BACKUP="${NVIM_INIT}.bak"
# }}}

# .vimrc/.vim backup and wipe {{{
# Backup and remove any existing .vimrc
if [ -f "$VIMRC" ]; then
    cp "$VIMRC" "$VIMRC_BACKUP"
    rm "$VIMRC"
fi

# Same for neovim init.vim
if [ -f "$NVIM_INIT" ]; then
    cp "$NVIM_INIT" "$NVIM_INIT_BACKUP"
    rm "$NVIM_INIT"
fi

# Backup and remove any existing .vim directory
if [ -d "$VIM_DIR" ]; then
    rm -rf "$VIM_DIR_BACKUP"
    mv -f "$VIM_DIR" "$VIM_DIR_BACKUP"
fi
# }}}

# vimrc/.vim creation and link {{{
mkdir -p "$VIM_DIR"
mkdir -p "$NVIM_DIR"

# Create symbolic link from $HOME/.vimrc to the .vimrc in this dir.
ln -s "$SCRIPT_DIR/vimrc" "$VIMRC"
# }}}

# Create similar link for neovim config
ln -s "$SCRIPT_DIR/neovim-init.vim" "$NVIM_INIT"

# first-time run colorscheme fix {{{
# Copy has.vim, used by first-time run of vim to avoid loading
# a not-yet-existent colorscheme.
mkdir -p "$VIM_DIR/autoload"
cp -f "$SCRIPT_DIR/has.vim" "$VIM_DIR/autoload/"
# }}}

# powerline font installation {{{
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
# }}}

# install Vundle and plugins {{{
# Clone Vundle
git clone https://github.com/VundleVim/Vundle.vim.git "$VIM_DIR/bundle/Vundle.vim"

# Install Vundle plugins
vim +VundleInstall +qall
# }}}

# plugin extra setup steps {{{
# Make vimproc.vim
VIMPROC_DIR="$VIM_DIR/bundle/vimproc.vim"
if [ -d "$VIMPROC_DIR" ]; then
    pushd "$VIMPROC_DIR"
    make
    popd
fi
# }}}

# install plugins from local repo {{{
# Copy over our ftplugin files if we have any.
if [ -d "${SCRIPT_DIR}/ftplugin" ]; then
    cp -r "${SCRIPT_DIR}/ftplugin" "${VIM_DIR}"
fi
# }}}

# Damien Conway Plugins {{{
# Here we're going to copy a selection of Damien Conway's plugins.
# I don't want all of them, so the strategy is to check out some
# of them to a temp directory, then copy over the ones we want.

# Wipe out the temp dir if it already exists.
DCONWAY_GIT_DIR=/tmp/dconway-vim
if [ -e "${DCONWAY_GIT_DIR}" ]; then
    rm -rf "${DCONWAY_GIT_DIR}"
fi

# clone his repo
git clone https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup.git "${DCONWAY_GIT_DIR}"
if [ $? == 0 ]; then
    # Ensure our plugin dir exists
    mkdir -p "${VIM_DIR}/plugin"

    # copy plugins that we want
    cp "${DCONWAY_GIT_DIR}/plugin/foldsearches.vim" "${VIM_DIR}/plugin/"
    cp "${DCONWAY_GIT_DIR}/plugin/visualguide.vim" "${VIM_DIR}/plugin/"
    cp "${DCONWAY_GIT_DIR}/plugin/yankmatches.vim" "${VIM_DIR}/plugin/"
fi

# clean up the temp directory
rm -rf /tmp/dconway-vim
# }}}

# tmux setup {{{
TMUX_DIR="$HOME/.tmux"
TMUX_DIR_BACKUP="${TMUX_DIR}.bak"
TMUX_CONF="$HOME/.tmux.conf"
TMUX_CONF_BACKUP="${TMUX_CONF}.bak"

# Backup and remove any .tmux directory
if [ -d "$TMUX_DIR" ]; then
    rm -rf "$TMUX_DIR" >/dev/null 2>&1
    mv -f "$TMUX_DIR" "$TMUX_DIR_BACKUP"
fi

# Install the tmux plugin manager
mkdir -p "$TMUX_DIR/plugins"
git clone https://github.com/tmux-plugins/tpm "$TMUX_DIR/plugins/tpm"

# Setup the .tmux.conf link
if [ -f "$TMUX_CONF" ]; then
    cp -f "$TMUX_CONF" "$TMUX_CONF_BACKUP"
    rm "$TMUX_CONF"
fi

# link ~/.tmux.conf to our repo one.
ln -s "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"

# force tmux package manager to install packages
"$TMUX_DIR/plugins/tpm/bin/install_plugins"

# }}}

