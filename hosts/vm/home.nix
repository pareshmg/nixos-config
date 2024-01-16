#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./vm
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ home.nix
#

{ pkgs, config, lib, profile, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
in
{
  imports =
    [
      #../../modules/desktop/bspwm/home.nix  #Window Manager
    ];

  home = {
    username = "${profile.user}";
    homeDirectory = "/home/${profile.user}";

    # Specific packages for desktop
    packages = (pkgs.callPackage ./packages.nix {}) ++  (pkgs.callPackage ../../shared/packages.nix {});
    file =  lib.mkMerge [
    ];

    stateVersion = "23.05";

  };
}
