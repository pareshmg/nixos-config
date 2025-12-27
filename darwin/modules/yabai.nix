{ config, lib, pkgs, ... }:

{
  services = {
    yabai = {
      # Tiling window manager
      enable = true;
      package = pkgs.yabai.overrideAttrs {
        # src = pkgs.fetchFromGitHub {
        #   owner = "koekeishiya";
        #   repo = "yabai";
        #   rev = "v6.0.11";
        #   hash = "sha256-HaflgZJ7QqooaSUNW+Uu0LD9+AVu4hHyJtILUrOC9+I=";
        # };
      };
      config = {
        # Other configuration options
        layout = "bsp";
        auto_balance = "off";
        split_ratio = "0.50";
        window_border = "off";
        window_border_width = "2";
        window_placement = "second_child";
        focus_follows_mouse = "off";
        mouse_follows_focus = "off";
        top_padding = "2";
        bottom_padding = "2";
        left_padding = "2";
        right_padding = "2";
        window_gap = "2";
      };
      extraConfig = ''
        yabai -m rule --add app="^System Preferences$" manage=off
        yabai -m rule --add app="^System Settings$" manage=off
        yabai -m rule --add app="^Finder$" manage=off
        yabai -m rule --add app="^iTerm2$" manage=off
        yabai -m rule --add app="^iTerm$" manage=off
        yabai -m rule --add app="^Emacs$" manage=off
        yabai -m rule --add app="^Finder$" manage=off
        yabai -m rule --add title=".*Preferences.*" manage=off
        yabai -m rule --add title=".*Settings.*" manage=off
        #yabai -m rule --add title="^(Opening)" manage=off
        yabai -m rule --add title="Library" manage=off
        yabai -m rule --add app="System" manage=off
        yabai -m rule --add app="Activity Monitor" manage=off
        yabai -m rule --add app="KeePassXC" manage=off
        yabai -m rule --add app="Karabiner-Elements" manage=off
      ''; # Specific rules for what is managed and layered.
    };
  };
}
