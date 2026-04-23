{ pkgs, profile, ... }:


{
  home = {
    username = profile.user;
    homeDirectory = "/home/${profile.user}";
    packages = with pkgs; [
      #mako
      #wl-clipboard
      #shotman
    ];
  };
  programs.home-manager.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # Super key
      terminal = "alacritty";
      output = {
        "Virtual-1" = {
          mode = "1440x900@30Hz";
        };
      };
    };
    extraConfig = ''
      bindsym Print               exec shotman -c output
      bindsym Print+Shift         exec shotman -c region
      bindsym Print+Shift+Control exec shotman -c window

      #output * bg ${pkgs.sway}/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill
    '';
  };
  home.stateVersion = "23.11";
}
