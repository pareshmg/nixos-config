{ config, lib, pkgs, specialArgs, ... }:

let
  inherit (specialArgs) profile u;
  location = "${config.home.homeDirectory}/.config/nixos-config";
  sharedFiles = import ../shared/files.nix { inherit config pkgs profile u location; };
in
{
  programs = {
    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = false;
        sync_address = "https://atuin.l.nervasion.com";
        update_check = false;
        search_mode = "fuzzy";
        filter_mode = "directory";
        style = "compact";
      };
      flags = [ "--disable-up-arrow" ];
    };
    ssh = {
      enable = true;
      includes = [ "per_ssh_config" "ssai_ssh_config" ];
    };
  };
  home = {
    file = sharedFiles;

    # activation = builtins.trace "setting up home activations" {
    #   myActivationAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #     $DRY_RUN_CMD echo "setting up ssh config by $(whoami)"
    #     $DRY_RUN_CMD mv -f ~/.ssh/config ~/.ssh/config.bak || true
    #     $DRY_RUN_CMD grep -hs ^ ~/.ssh/*_ssh_config > ~/.ssh/config || mv -f ~/.ssh/config.bak ~/.ssh/config
    #     $DRY_RUN_CMD chmod 600 ~/.ssh/config
    #   '';
    # };
    stateVersion = "23.11";
  };
}
