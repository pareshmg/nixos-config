{ dict, prefix ? "" }:
with builtins;
let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) lib;
  f = { prefix, x }:
    if isAttrs x
    then concatMap (y: f { prefix = if (stringLength prefix) > 0 then prefix + "." + y else y; x = getAttr y x; }) (attrNames x)
    else [{ name = prefix; value = x; }];
  tmp = f { inherit prefix; x = dict; };
in
listToAttrs tmp
