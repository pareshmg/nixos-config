#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ lib, home-manager, agenix, secrets, config, pkgs, profile, cmtnix, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  user = profile.user;
in
{
  cmt = {
    localuser = secrets.profile.work.user;
    cmtuser = secrets.profile.work.email;
    roles = secrets.profile.work.cmtnix_roles;
    cmtgroup = secrets.profile.work.cmtgroup;
  };

  age = {
    secrets = {
      cmt_aws_daily_roles = {
        file = secrets.cmt.daily_roles;
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
    extraSpecialArgs = {cmtcfg = config.cmt;};
    users.${user}.imports = [
      cmtnix.homeManagerModules.cmtaws
      ./home-cmt.nix
    ];
  };

}
