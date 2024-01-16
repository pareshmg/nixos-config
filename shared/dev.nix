{ config, lib, pkgs, ... }:

{
  imports =
    # (import ../modules/editors) ++          # Native doom emacs instead of nix-community flake
    (import ../modules/shell);

}
