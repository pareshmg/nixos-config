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
in
{

  age = builtins.trace "secrets has home dir ${config.users.users.${profile.user}.home}" {
    secrets = {
      per_ssh_config = {
        file = secrets.per.ssh_config;
        path = builtins.trace "per_ssh_config at ${secrets.per.ssh_config}" "${config.users.users.${profile.user}.home}/.ssh/per_ssh_config";
        owner = "${profile.user}";
        mode = "660";
        symlink = false;
     };
      android_signing_key = {
        file = builtins.trace "android_signing_key at ${secrets.per.android_signing_key}" secrets.per.android_signing_key;
        path = "${config.users.users.${profile.user}.home}/android_signing_key.jks";
      };
    };
    identityPaths = profile.identityPaths;
  };


}
