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

{ lib, config, pkgs, profile, specialArgs, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  inherit (specialArgs) profile;
in
{
  imports = [
    ../modules/programs/tex.nix
  ];

  home = {
    packages = (pkgs.callPackage ./packages.nix { })
      ++ (pkgs.callPackage ../shared/packages.nix { })
      ++ (pkgs.callPackage ./packages-per.nix { });


    activation = builtins.trace "setting up home activations" {
      configActivationAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD cat "$HOME/Library/Application Support/KeepassXC/keepassxc.ini.orig" || true # > "$HOME/Library/Application Support/KeepassXC/keepassxc.ini || true"
      '';
    };
  };
}
