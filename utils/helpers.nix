{ config, lib, pkgs, ... }:
let
  nested_dict_to_flat = import ./nested_dict_to_flat.nix;
in
{
  template_substitute = {text, subst_dict ? {}, prefix ? ""}:
    let
      fdict = nested_dict_to_flat {dict=subst_dict; prefix=prefix;};
      res = 1;
    in
      res;
}
