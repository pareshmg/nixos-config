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
    packages = (pkgs.callPackage ./packages.nix {})
               ++  (pkgs.callPackage ../shared/packages.nix {})
               ++ (pkgs.callPackage ./packages-per.nix {});
  };
}
