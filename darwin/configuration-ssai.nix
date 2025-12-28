#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ lib, inputs, home-manager, system, agenix, secrets, config, pkgs, profile, u, cmtnix, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  inherit (profile) user;
in
{
  #ssai = secrets.profile.work.ssai;
  #services.cmtLLM.enable = true;


  # Enable home-manager
  home-manager = {
    extraSpecialArgs = { inherit secrets u; };
    users.${user}.imports = [
      inputs.snix.homeManagerModules.default
      ./home-ssai.nix
    ];
  };

  # Use Darwin-specific packages
  nixpkgs.pkgs = import inputs.nixpkgs-darwin {
    inherit system;
    overlays = [ inputs.snix.overlays.default ];
    config = { allowUnfree = true; };
  };
  home-manager.useGlobalPkgs = true;

  ssai = {
    nix-container-builders = {
      x86_64-linux.enable = true;
      aarch64-linux.enable = true;
      public-key = "/Users/${user}/.ssh/ssai_local_builders_id_ed25519.pub";
      private-key = "/Users/${user}/.ssh/ssai_local_builders_id_ed25519";
      trusted-user = user;
    };
  };

  homebrew = {
    casks = [
      #"google-earth-pro" # needs sudo to install and messes things up.
      #"openvpn-connect"
      "rancher"
    ];
  };

}
