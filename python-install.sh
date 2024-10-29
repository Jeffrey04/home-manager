#!/usr/bin/env sh

export CPPFLAGS="-I$HOME/.nix-profile/include $CPPFLAGS"
export CFLAGS="-I$HOME/.nix-profile/include $CFLAGS"
export LDFLAGS="-L$HOME/.nix-profile/lib $LDFLAGS"
export PKG_CONFIG_PATH=$HOME/.nix-profile/lib/pkgconfig:$HOME/.nix-profile/share/pkgconfig:$PKG_CONFIG_PATH
export C_INCLUDE_PATH=$HOME/.nix-profile/include:$C_INCLUDE_PATH
export INCLUDE_PATH=$HOME/.nix-profile/include:$INCLUDE_PATH
export LIBRARY_PATH=$HOME/.nix-profile/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/.nix-profile/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/.nix-profile/lib/pkgconfig:$HOME/.nix-profile/share/pkgconfig:$PKG_CONFIG_PATH

$HOME/.nix-profile/bin/pyenv install -vf 3.12.6