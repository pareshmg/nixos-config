#
#  Home-manager configuration for cmt
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   ├─ ./home.nix
#   │   └─ ./home-cmt.nix *
#

{ lib, secrets, u, ... }:

{
  home = {                                        # Specific packages for macbook
    file =  lib.mkMerge [
      { ".cmt".source = u.getOrDefault secrets "cmt.aliases" ""; }
    ];
  };

}
