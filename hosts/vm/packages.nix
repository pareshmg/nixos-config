{ lib, pkgs }:

with pkgs;
[
  ansible
  sshpass # for ansible
  terraform
  git-lfs
  (lib.hiPrio (ollama-master.override {acceleration="cuda";}))
]
