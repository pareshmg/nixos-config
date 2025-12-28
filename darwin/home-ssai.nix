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
  home = {
    # Specific packages for macbook
    file = lib.mkMerge [
      { ".ssai".source = u.getOrDefault secrets "ssai.aliases" ""; }
    ];
  };

}
