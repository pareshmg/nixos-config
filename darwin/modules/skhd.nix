{ config, lib, pkgs, ... }:

let
  hyper = "rcmd + rshift + ralt + rctrl";
  basemod = "lcmd + lctrl";

in
{
  services = {
    skhd = {
      # Hotkey daemon
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        # Open Terminal
        # alt - return : /Applications/Alacritty.App/Contents/MacOS/alacritty

        # Toggle Window
        ${basemod} - t : yabai -m window --toggle float && yabai -m window --grid 4:4:1:1:2:2
        ${basemod} - f : yabai -m window --toggle zoom-fullscreen
        ${basemod} - q : yabai -m window --close

        # Focus Window
        ${basemod} - i : yabai -m window --focus north
        ${basemod} - k : yabai -m window --focus south
        ${basemod} - j : yabai -m window --focus west
        ${basemod} - l : yabai -m window --focus east

        # Swap Window
        lshift + ${basemod} - i : yabai -m window --swap north
        lshift + ${basemod} - k : yabai -m window --swap south
        lshift + ${basemod} - j : yabai -m window --swap west
        lshift + ${basemod} - l : yabai -m window --swap east

        # Resize Window
        ${basemod} - a : yabai -m window --resize left:-50:0 && yabai -m window --resize right:-50:0
        ${basemod} - d : yabai -m window --resize left:50:0 && yabai -m window --resize right:50:0
        ${basemod} - w : yabai -m window --resize up:-50:0 && yabai -m window --resize down:-50:0
        ${basemod} - s : yabai -m window --resize up:-50:0 && yabai -m window --resize down:-50:0

        # Focus Space
        ${basemod} - 1 : yabai -m space --focus 1
        ${basemod} - 2 : yabai -m space --focus 2
        ${basemod} - 3 : yabai -m space --focus 3
        ${basemod} - 4 : yabai -m space --focus 4
        ${basemod} - 5 : yabai -m space --focus 5
        # ${basemod} - [ : yabai -m space --focus prev
        # ${basemod} - ] : yabai -m space --focus next

        # Send to Space
        # shift + ctrl - 1 : yabai -m window --space 1
        # shift + ctrl - 2 : yabai -m window --space 2
        # shift + ctrl - 3 : yabai -m window --space 3
        # shift + ctrl - 4 : yabai -m window --space 4
        # shift + ctrl - 5 : yabai -m window --space 5
        # shift + ctrl - left : yabai -m window --space prev && yabai -m space --focus prev
        # shift + ctrl - right : yabai -m window --space next && yabai -m space --focus next

        # Menu
        # cmd + space : for now its using the default keybinding to open Spotlight Search
      ''; # Hotkey config
    };
  };

  system = {
    keyboard = {
      enableKeyMapping = true; # Needed for skhd
    };
  };

  environment.systemPackages = [ pkgs.skhd ];
}
