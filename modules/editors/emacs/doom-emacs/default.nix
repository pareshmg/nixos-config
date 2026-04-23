#
# Doom Emacs: Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
# This is an ideal way to install on a vanilla NixOS installion.
# You will need to import this from somewhere in the flake (Obviously not in a home-manager nix file)
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ ./doom-emacs
#                   └─ ./alt
#                       └─ native.nix *
#


{ config, pkgs, ... }:
let
  doom-sync = pkgs.callPackage ./doom-sync.nix { };
in
{
  #services.emacs.enable = true;
  environment.systemPackages = [ doom-sync ];
  # system.userActivationScripts = {
  #   # Installation script every time nixos-rebuild is run. So not during initial install.
  #   doomEmacs = {
  #     text = ''
  #       #!/bin/sh
  #       ${doom-sync}/bin/doom-sync
  #     ''; # It will always sync when rebuild is done. So changes will always be applied.
  #   };
  # };

}
