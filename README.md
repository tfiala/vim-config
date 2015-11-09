# My vim setup

## Quick Start 
```
git clone http://github.com/tfiala/vim-setup
cd vim-setup
./setup.sh
```

## Details

The above script will backup any existing .vimrc file and .vim directory in
your home directory to the same with a .bak extension.  It will then overwrite
them with my Vundle-based setup.

It installs [Powerline Fonts](https://github.com/powerline/fonts).  It assumes
that the "Source/Sauce Code Pro (Powerline)" font is set if using the
terminal-based vim.  If using macvim/gvim, it should work fine as the
installer for the Powerline fonts is run as part of the setup.sh script.

## My Typical Setup

I am most often running on OS X from within [iTerm 2](http://iterm2.com), using
one of the [Solarized](http://ethanschoonover.com/solarized) color profiles, but
frequently I use this setup on Ubuntu-based Linux systems.

