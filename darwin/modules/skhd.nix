{ config, lib, pkgs, ... }:

let
  hyper = "rcmd + rshift + ralt + rctrl";
  basemod = "cmd + ctrl";
  yabaicmd = "${pkgs.yabai}/bin/yabai";
in
{
  services = {
    skhd = {
      # Hotkey daemon
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        # Open Terminal
        ${basemod} - y : echo "hi, test works" > /tmp/skhd_test.txt

        # Toggle Window
        ${basemod} - t : ${yabaicmd} -m window --toggle float && ${yabaicmd} -m window --grid 4:4:1:1:2:2
        ${basemod} - f : ${yabaicmd} -m window --toggle zoom-fullscreen
        ${basemod} - q : ${yabaicmd} -m window --close

        # Focus Window
        ${basemod} - i : ${yabaicmd} -m window --focus north
        ${basemod} - k : ${yabaicmd} -m window --focus south
        ${basemod} - j : ${yabaicmd} -m window --focus west
        ${basemod} - l : ${yabaicmd} -m window --focus east

        # Swap Window
        shift + ${basemod} - i : ${yabaicmd} -m window --swap north
        shift + ${basemod} - k : ${yabaicmd} -m window --swap south
        shift + ${basemod} - j : ${yabaicmd} -m window --swap west
        shift + ${basemod} - l : ${yabaicmd} -m window --swap east

        # Resize Window
        # ${basemod} - a : ${yabaicmd} -m window --resize left:-50:0 && ${yabaicmd} -m window --resize right:-50:0
        # ${basemod} - d : ${yabaicmd} -m window --resize left:50:0 && ${yabaicmd} -m window --resize right:50:0
        ${basemod} - a : ${yabaicmd} -m window --ratio rel:-0.05
        ${basemod} - d : ${yabaicmd} -m window --ratio rel:0.05
        ${basemod} - w : ${yabaicmd} -m window --resize up:-50:0 && ${yabaicmd} -m window --resize down:-50:0
        ${basemod} - s : ${yabaicmd} -m window --resize up:50:0 && ${yabaicmd} -m window --resize down:50:0

        # Focus Space
        # ${basemod} - 1 : ${yabaicmd} -m space --focus 1
        # ${basemod} - 2 : ${yabaicmd} -m space --focus 2
        # ${basemod} - 3 : ${yabaicmd} -m space --focus 3
        # ${basemod} - 4 : ${yabaicmd} -m space --focus 4
        # ${basemod} - 5 : ${yabaicmd} -m space --focus 5
        # ${basemod} - [ : ${yabaicmd} -m space --focus prev
        # ${basemod} - ] : ${yabaicmd} -m space --focus next

        # Multiple displays
        ${basemod} - 1 : ${yabaicmd} -m window --display next


        # Send to Space
        # shift + ctrl - 1 : ${yabaicmd} -m window --space 1
        # shift + ctrl - 2 : ${yabaicmd} -m window --space 2
        # shift + ctrl - 3 : ${yabaicmd} -m window --space 3
        # shift + ctrl - 4 : ${yabaicmd} -m window --space 4
        # shift + ctrl - 5 : ${yabaicmd} -m window --space 5
        # shift + ctrl - left : ${yabaicmd} -m window --space prev && ${yabaicmd} -m space --focus prev
        # shift + ctrl - right : ${yabaicmd} -m window --space next && ${yabaicmd} -m space --focus next

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
