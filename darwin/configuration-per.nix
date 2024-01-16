#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ lib, home-manager, agenix, secrets, u, config, pkgs, profile, cmtnix, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  user = profile.user;
  mm = (u.getOrDefault secrets "utils.mm" (_: "")) pkgs;
in
{
  environment.systemPackages = [ mm ];
  homebrew = {                            # Declare Homebrew using Nix-Darwin
    casks = (pkgs.callPackage ./casks.nix {}) ++ (pkgs.callPackage ./casks-per.nix {});
  };
  home-manager = {
    extraSpecialArgs = {inherit secrets u;} ;
    users.${user}.imports = [
      ./home-per.nix
    ];
  };

  age = {
    secrets = {
      keepassxc_ini = {
        file = secrets.per.keepassxc_ini;
        path = "${config.users.users.${user}.home}/Library/Application Support/KeepassXC/keepassxc.ini.orig";
        owner = "${user}";
        mode = "660";
      };
    };
  };

}
