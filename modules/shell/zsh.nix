#
# Shell
#

{ lib, config, pkgs, profile, ... }:

{
  programs = {
    zsh = {
      enable = true;
      #autosuggestions.enable = true;            # Auto suggest options and highlights syntax, searches in history for options
      #     syntaxHighlighting.enable = true;
      enableCompletion = false; #will be enabled in source to prevent multiple loads and slowdown
      #     #defaultKeymap = "emacs";
      #     #histSize = 100000;
      #     interactiveShellInit = ''                            # Zsh theme
      #       if [ -f ~/.profile_personal ]; then
      #           source ~/.profile_personal
      #       fi
      #       #autoload -U promptinit; promptinit
      #       # Hook direnv
      #       #emulate zsh -c "$(direnv hook zsh)"
      #       #eval "$(direnv hook zsh)"
      #     '';


      #     # ohMyZsh = {                               # Extra plugins for zsh
      #     #   enable = true;
      #     #   plugins = [
      #     #     "git"
      #     #     "history-substring-search"
      #     #     "tmux"
      #     #     "per-directory-history"
      #     #     "docker"
      #     #     "kubectl"
      #     #     "z"
      #     #   ];
      #     # };

    };
  };
  home-manager.users.${profile.user} = { pkgs, ... }: {
    programs = {
      zsh = (import ./zsh-home.nix { inherit config lib pkgs; });
    };
  };
}
