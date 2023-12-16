#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ lib, home-manager, agenix, secrets, config, pkgs, profile, location, hostname, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  user = profile.user;
in
{

  homebrew = {                            # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = false;                 # Auto update packages
      upgrade = false;
      cleanup = "zap";                    # Uninstall not listed packages and casks
    };
    brews = pkgs.callPackage ./brews.nix {};
    casks = (pkgs.callPackage ./casks.nix {}) ++ (pkgs.callPackage ./casks-home.nix {});
    masApps = { # search via mas search
      #"1password" = 1333542190;
      "Xcode" = 497799835;
    };
  };


  age = {
    secrets = {
      cmt_aws_daily_roles = {
        file = builtins.trace "cmt_daily_roles ${secrets.cmt.daily_roles}" secrets.cmt.daily_roles;
        path = "${config.users.users.${user}.home}/.aws/daily-roles.yaml";
        owner = "${user}";
        mode = "660";
        symlink = false;
      };
      cmt_ssh_config = {
        file = builtins.trace "cmt_ssh_config at ${secrets.cmt.ssh_config}" secrets.cmt.ssh_config;
        path = "${config.users.users.${user}.home}/.ssh/cmt_ssh_config";
        owner = "${user}";
        mode = "660";
        symlink = false;
      };
    };
    identityPaths = profile.identityPaths;
  };



  # Enable home-manager
  home-manager = {
    users.${user} = import ./home-cmt.nix { inherit pkgs config agenix secrets location home-manager lib; };
  };

}
