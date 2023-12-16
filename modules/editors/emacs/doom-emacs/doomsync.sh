#!/usr/bin/env bash
source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
EMACS="$HOME/.config/emacs"
DOOMDIR="$HOME/.config/doom"

if [ ! -d "$EMACS" ]; then
    ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs.git $EMACS
    yes | $EMACS/bin/doom install
fi
$EMACS/bin/doom sync
