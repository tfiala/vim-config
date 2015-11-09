#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

# Install Vundle plugins
vim +VundleInstall +qall

