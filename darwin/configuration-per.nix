#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ lib, home-manager, agenix, secrets, config, pkgs, profile, cmtnix, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  user = profile.user;
in
{
  homebrew = {                            # Declare Homebrew using Nix-Darwin
    casks = (pkgs.callPackage ./casks.nix {}) ++ (pkgs.callPackage ./casks-per.nix {});
  };
  home-manager = {
    extraSpecialArgs = {inherit secrets;} ;
    users.${user}.imports = [
      ./home-per.nix
    ];
  };

}
