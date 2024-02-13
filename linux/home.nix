#
#  Home-manager configuration for macbook
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   └─ ./home.nix *
#   └─ ./modules
#       └─ ./programs
#           └─ ./alacritty.nix
#

{ lib, config, pkgs, agenix, home-manager, secrets, specialArgs, location, ... }:

let
  inherit (specialArgs) profile u;
  sharedFiles = import ../shared/files.nix { inherit config pkgs profile u; };
in
{

  nixpkgs.config.allowUnfree = true;
  home = {
    username = "${profile.user}";
    homeDirectory = "/home/${profile.user}";
    packages = (pkgs.callPackage ./packages.nix { }) ++ (pkgs.callPackage ../shared/system-packages.nix { }) ++ (pkgs.callPackage ../shared/packages.nix { });
    stateVersion = "23.11";
    enableNixpkgsReleaseCheck = false;
    file = lib.mkMerge [
      sharedFiles
    ];
  };
  programs = {
    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      # syntaxHighlighting.enable = true;
      enableCompletion = false;
      initExtra = ''                            # Zsh theme
          if [ -f ~/.profile_personal ]; then
              source ~/.profile_personal
          fi
          if [ -f ~/.cmt ]; then
              source ~/.cmt
          fi
          #autoload -U promptinit; promptinit
          # Hook direnv
          #emulate zsh -c "$(direnv hook zsh)"
          #eval "$(direnv hook zsh)"
        '';

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ../modules/shell/p10k-config;
          file = "p10k.zsh";
        }
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "history-substring-search"
          "tmux"
          "per-directory-history"
          "docker"
          "kubectl"
          "z"
        ];

      };
    };
  };
}
