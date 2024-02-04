#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ lib, home-manager, agenix, secrets, config, pkgs, profile, u, cmtnix, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  user = profile.user;
in
{
  cmt = secrets.profile.work.cmt;
  age = {
    secrets = {
      cmt_aws_daily_roles = {
        file = secrets.cmt.cmt_aws_daily_roles;
        path = "${config.users.users.${user}.home}/.aws/daily-roles.yaml";
        owner = "${user}";
        mode = "660";
        symlink = false;
      };
      cmt_ssh_config = {
        #file = builtins.trace "cmt_ssh_config at ${secrets.cmt.ssh_config}" secrets.cmt.ssh_config;
        file = secrets.cmt.ssh_config;
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
    extraSpecialArgs = { inherit secrets u; } ;
    users.${user}.imports = [
      cmtnix.homeManagerModules.cmtnix
      ./home-cmt.nix
    ];
  };

}
