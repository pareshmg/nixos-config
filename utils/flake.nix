{
  description = "My nix utils";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };
  outputs = {self, nixpkgs, ...} @ inputs:
    let
      lib = nixpkgs.lib;
      helpers = import ./helpers.nix {inherit lib;};
    in
      {
        recursiveMerge = helpers.recursiveMerge;
        getOrDefault = helpers.getOrDefault;
      };
}
