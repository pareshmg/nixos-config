{ pkgs }:

with pkgs; [
  # Default packages installed system-wide
  curl
  jq
  git
  killall
  tmux
  nixos-generators
  
  # emacs for all
  my-emacs
  
  fd
  ripgrep
  coreutils

]
