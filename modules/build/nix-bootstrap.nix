{ pkgs }:

pkgs.writeShellApplication {
  name = "nix-bootstrap";
  runtimeInputs = with pkgs; [ git openssh ];
  text = builtins.readFile ./nix-bootstrap.sh;
}
