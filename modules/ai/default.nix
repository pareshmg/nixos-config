{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #claude-code
    codex-unstable
    opencode-unstable
    aider-chat
  ];
}
