#
#  Home-manager configuration for cmt
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   ├─ ./home.nix
#   │   └─ ./home-cmt.nix *
#

{ config, lib, pkgs, home-manager,  agenix, secrets, location, ... }:

let
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  sharedFiles = import ../shared/files.nix { inherit config pkgs location; };
in
{
  home = {                                        # Specific packages for macbook
    packages = (pkgs.callPackage ../shared/packages-cmt.nix {});
    file =  lib.mkMerge [
      { ".cmt".source = ../shared/config/cmt; }
      # { "test".text = secrets.test1; }
      # { ".ssh/config_source" = {
      #     text = (builtins.readFile ../shared/config/ssh/config-cmt);
      #     onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 600 ~/.ssh/config'';
      #   };
      # }
    ];
    # activation = {
    #   myActivationAction = home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
    #     $DRY_RUN_CMD echo "myActivationAction running"
    #     $DRY_RUN_CMD grep -hs ^ ~/.ssh/config_source ~/.ssh/cmt_config_source > ~/.ssh/config || true
    #     $DRY_RUN_CMD chmod 600 ~/.ssh/config
    #   '';
    # };

  };

}
