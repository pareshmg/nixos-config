#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ lib, home-manager, agenix, secrets, config, pkgs, profile, location, hostname, ... }:

{

  age = {
    secrets = {
      ssai_ssh_config = {
        file = secrets.ssai.ssh_config;
        path = "${config.users.users.${profile.user}.home}/.ssh/ssai_ssh_config";
        owner = "${profile.user}";
        mode = "600";
        symlink = false;
      };
      # cachix_read_auth = {
      #   file = secrets.ssai.cachix_read_auth;
      #   path = "${config.users.users.${profile.user}.home}/.config/cachix/cachix.dhall";
      #   owner = "${profile.user}";
      #   mode = "660";
      #   symlink = false;
      # };
      cachix_rw_auth = {
        file = secrets.ssai.cachix_rw_auth;
        path = "${config.users.users.${profile.user}.home}/.config/cachix/cachix.dhall";
        owner = "${profile.user}";
        mode = "660";
        symlink = false;
      };
      authinfo = {
        file = secrets.ssai.authinfo;
        path = "${config.users.users.${profile.user}.home}/.authinfo";
        owner = "${profile.user}";
        mode = "660";
        symlink = false;
      };
    };
    inherit (profile) identityPaths;
  };


}
