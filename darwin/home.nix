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

{ lib, config, pkgs, specialArgs, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  inherit (specialArgs) profile;
in
{
  home = {
    packages = (pkgs.callPackage ./packages.nix { }) ++ (pkgs.callPackage ../shared/packages.nix { });
    stateVersion = "23.11";
    enableNixpkgsReleaseCheck = false;
    file = lib.mkMerge [
      #additionalFiles
      #{ "emacs-launcher.command".source = myEmacsLauncher; }
      {
        ".config/iterm2" = {
          source = ../shared/config/iterm2;
          recursive = true;
          onChange = ''
            # Specify the preferences directory
            /usr/bin/defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.config/iterm2"

            # Tell iTerm2 to use the custom preferences in the directory
            /usr/bin/defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
          '';
        };
      }
    ];
    sessionPath = [
      "/System/Volumes/Data/opt/homebrew/bin"
    ];
  };
  programs = {
    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
  };


  # programs = {
  #   zsh = {                                       # Post installation script is run in configuration.nix to make it default shell
  #     enable = true;
  #     enableAutosuggestions = true;               # Auto suggest options and highlights syntax. It searches in history for options
  #     enableSyntaxHighlighting = true;
  #     history.size = 10000;

  #     oh-my-zsh = {                               # Extra plugins for zsh
  #       enable = true;
  #       plugins = [ "git" ];
  #       custom = "$HOME/.config/zsh_nix/custom";
  #     };

  #     initExtra = ''
  #       # Spaceship
  #       source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
  #       autoload -U promptinit; promptinit
  #       pfetch
  #     '';                                         # Zsh theme
  #   };

  # };
}
