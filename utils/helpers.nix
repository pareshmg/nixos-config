{ lib, ... }:
let
  nested_dict_to_flat = import ./nested_dict_to_flat.nix;
  getOrDefault = set: key: default:
    let
      keys = lib.splitString "." key;
      key0 = builtins.head keys;
      rest = builtins.tail keys;
    in
    (if (builtins.length keys) == 1
    then (if builtins.hasAttr key0 set then builtins.getAttr key0 set else default)
    else (if builtins.hasAttr key0 set then (getOrDefault (builtins.getAttr key0 set) (builtins.concatStringsSep "." rest) default) else default));
  recursiveMerge = attrList: builtins.foldl' lib.attrsets.recursiveUpdate { } attrList;
in
{
  inherit getOrDefault recursiveMerge;
  template_substitute = { text, subst_dict ? { }, prefix ? "" }:
    let
      fdict = nested_dict_to_flat { dict = subst_dict; prefix = prefix; };
      res = 1;
    in
    res;
}
