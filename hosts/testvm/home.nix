{ pkgs, profile, ... }:

let
  mod = "Mod4";
in
{

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
    };
  };

  programs.home-manager.enable = true;
  home = {
    username = profile.user;
    homeDirectory = "/home/${profile.user}";
    packages = with pkgs; [
      #mako
      #wl-clipboard
      #shotman
    ];
    stateVersion = "23.11";
  };
}
