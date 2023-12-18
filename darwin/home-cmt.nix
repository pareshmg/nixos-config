#
#  Home-manager configuration for cmt
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   ├─ ./home.nix
#   │   └─ ./home-cmt.nix *
#

{ lib, ... }:

{
  home = {                                        # Specific packages for macbook
    file =  lib.mkMerge [
      { ".cmt".source = ../shared/config/cmt; }
    ];
  };

}
