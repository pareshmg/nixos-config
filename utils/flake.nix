{
  description = "My nix utils";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };
  outputs = { self, nixpkgs, ... } @ inputs:
    let
      inherit (nixpkgs) lib;
      helpers = import ./helpers.nix { inherit lib; };
      templateSubstitute = import ./template_substitute.nix;
    in
    {
      inherit templateSubstitute;
      substProfile = profile: fname: templateSubstitute { subst_dict = profile; text = builtins.readFile fname; };
      inherit (helpers) recursiveMerge;
      inherit (helpers) getOrDefault;
    };
}
