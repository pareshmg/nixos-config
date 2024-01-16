{ pkgs }:

with pkgs; [
  # Default packages installed system-wide
  curl
  jq
  git
  killall
  tmux

  # emacs for all
  emacs29-nox
  fd
  ripgrep
  coreutils

]
