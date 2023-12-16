{ pkgs }:

with pkgs; [
  # cmtaws
  pipx
  wget
  awscli2
  groff
  ssm-session-manager-plugin
]
