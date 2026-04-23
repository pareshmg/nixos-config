{ text, subst_dict ? { }, prefix ? "" }:
let
  nested_dict_to_flat = import ./nested_dict_to_flat.nix;
  fdict = nested_dict_to_flat { dict = subst_dict; inherit prefix; };
  template = map (x: "{{" + x + "}}") (builtins.attrNames fdict);
  subst = builtins.attrValues fdict;
in
builtins.replaceStrings template subst text
