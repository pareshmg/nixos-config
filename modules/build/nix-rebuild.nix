{ pkgs }:

pkgs.writeShellApplication {
  name = "nix-rebuild";
  runtimeInputs = with pkgs; [ git openssh ];
  text = builtins.replaceStrings ["SYSTEM=\"\""] ["SYSTEM=\"${pkgs.system}\""] (builtins.readFile ./nix-rebuild.sh);
}
