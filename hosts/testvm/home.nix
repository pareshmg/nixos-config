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

  home.username = profile.user;
  home.homeDirectory = "/home/${profile.user}";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    #mako
    #wl-clipboard
    #shotman
  ];
  home.stateVersion = "23.11";
}
