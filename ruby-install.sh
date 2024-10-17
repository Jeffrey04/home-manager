#!/usr/bin/env sh

export CPPFLAGS="-I/home/jeffrey04/.nix-profile/include $CPPFLAGS"
export CFLAGS="-I/home/jeffrey04/.nix-profile/include $CFLAGS"
export LDFLAGS="-L/home/jeffrey04/.nix-profile/lib $LDFLAGS"
export PKG_CONFIG_PATH=$HOME/.nix-profile/lib/pkgconfig:$HOME/.nix-profile/share/pkgconfig:$PKG_CONFIG_PATH
export C_INCLUDE_PATH=$HOME/.nix-profile/include:$C_INCLUDE_PATH
export INCLUDE_PATH=$HOME/.nix-profile/include:$INCLUDE_PATH
export LIBRARY_PATH=$HOME/.nix-profile/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/.nix-profile/lib:$LD_LIBRARY_PATH

$HOME/.nix-profile/bin/rbenv install -vf 3.3.5