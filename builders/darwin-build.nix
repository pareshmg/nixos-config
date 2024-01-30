{ pkgs, darwin, system }:
flake:
pkgs.writeShellApplication {
  name = "darwin-build";
  runtimeInputs = with pkgs; [ darwin.packages.${system}.darwin-rebuild ];
  text = ''
    cd ~/nixos-config
    nix --experimental-features 'nix-command flakes' build .#darwinConfigurations.${system}.${flake}.system "$@"
    darwin-rebuild switch --flake .#${system}.cmtmac
  '';
}
