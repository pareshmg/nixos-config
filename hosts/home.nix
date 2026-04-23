#
#  General Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix *
#   └─ ./modules
#       ├─ ./programs
#       │   └─ default.nix
#       └─ ./services
#           └─ default.nix
#

{ config, lib, pkgs, profile, ... }:

{
  #imports =                                   # Home Manager Modules
  #(import ../modules/programs) ++
  #(import ../modules/services);

  home = {
    username = "${profile.user}";
    homeDirectory = "/home/${profile.user}";

    packages = with pkgs; [
      # Terminal
      #btop              # Resource Manager
      #ranger            # File Manager
      #tldr              # Helper

      # emacs
      #sqlite

      # dev
      ansible
      sshpass # for ansible
      terraform
      git-lfs

      # # Video/Audio
      # feh               # Image Viewer
      # mpv               # Media Player
      # pavucontrol       # Audio Control
      # plex-media-player # Media Player
      # vlc               # Media Player
      # stremio           # Media Streamer

      # # Apps
      # appimage-run      # Runs AppImages on NixOS
      # firefox           # Browser
      # google-chrome     # Browser
      # remmina           # XRDP & VNC Client

      # # File Management
      # gnome.file-roller # Archive Manager
      # okular            # PDF Viewer
      # pcmanfm           # File Manager
      # p7zip             # Zip Encryption
      # rsync             # Syncer - $ rsync -r dir1/ dir2/
      # unzip             # Zip Files
      # unrar             # Rar Files
      # zip               # Zip

      # General configuration
      #git              # Repositories
      #killall          # Stop Applications
      #nano             # Text Editor
      #pciutils         # Computer Utility Info
      #pipewire         # Sound
      #usbutils         # USB Utility Info
      #wacomtablet      # Wacom Tablet
      #wget             # Downloader
      #zsh              # Shell
      #
      # General home-manager
      #alacritty        # Terminal Emulator
      #dunst            # Notifications
      #doom emacs       # Text Editor
      #libnotify        # Dependency for Dunst
      #neovim           # Text Editor
      #rofi             # Menu
      #rofi-power-menu  # Power Menu
      #udiskie          # Auto Mounting
      #vim              # Text Editor
      #
      # Xorg configuration
      #xclip            # Console Clipboard
      #xorg.xev         # Input Viewer
      #xorg.xkill       # Kill Applications
      #xorg.xrandr      # Screen Settings
      #xterm            # Terminal
      #
      # Xorg home-manager
      #flameshot        # Screenshot
      #picom            # Compositer
      #sxhkd            # Shortcuts
      #
      # Wayland configuration
      #autotiling       # Tiling Script
      #grim             # Image Grabber
      #slurp            # Region Selector
      #swappy           # Screenshot Editor
      #swayidle         # Idle Management Daemon
      #wev              # Input Viewer
      #wl-clipboard     # Console Clipboard
      #wlr-randr        # Screen Settings
      #xwayland         # X for Wayland
      #
      # Wayland home-manager
      #mpvpaper         # Video Wallpaper
      #pamixer          # Pulse Audio Mixer
      #swaybg           # Background
      #swaylock-fancy   # Screen Locker
      #waybar           # Bar
      #
      # Desktop
      #ansible          # Automation
      #blueman          # Bluetooth
      #deluge           # Torrents
      #discord          # Chat
      #ffmpeg           # Video Support (dslr)
      #gmtp             # Mount MTP (GoPro)
      #gphoto2          # Digital Photography
      #handbrake        # Encoder
      #heroic           # Game Launcher
      #hugo             # Static Website Builder
      #lutris           # Game Launcher
      #mkvtoolnix       # Matroska Tool
      #plex-media-player# Media Player
      #prismlauncher    # MC Launcher
      #steam            # Games
      #simple-scan      # Scanning
      #sshpass          # Ansible dependency
      #
      # Laptop
      #cbatticon        # Battery Notifications
      #blueman          # Bluetooth
      #light            # Display Brightness
      #libreoffice      # Office Tools
      #simple-scan      # Scanning
      #
      # Flatpak
      #obs-studio       # Recording/Live Streaming
    ];

    # manage dotfiles
    #file.".p10k.zsh".source = ../dotfiles/homelinks/p10k.zsh;

    # file.".config/wall".source = ../modules/themes/wall;
    # file.".config/wall.mp4".source = ../modules/themes/wall.mp4;
    # pointerCursor = {                         # This will set cursor system-wide so applications can not choose their own
    #   gtk.enable = true;
    #   name = "Dracula-cursors";
    #   #name = "Catppuccin-Mocha-Dark-Cursors";
    #   package = pkgs.dracula-theme;
    #   #package = pkgs.catppuccin-cursors.mochaDark;
    #   size = 16;
    # };
    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;
  };

  # gtk = {                                     # Theming
  #   enable = true;
  #   theme = {
  #     name = "Dracula";
  #     #name = "Catppuccin-Mocha-Compact-Mauve-Dark";
  #     package = pkgs.dracula-theme;
  #     #package = pkgs.catppuccin-gtk.override {
  #     #  accents = ["mauve"];
  #     #  size = "compact";
  #     #  variant = "mocha";
  #     #};
  #   };
  #   iconTheme = {
  #     name = "Papirus-Dark";
  #     package = pkgs.papirus-icon-theme;
  #   };
  #   font = {
  #     #name = "JetBrains Mono Medium";
  #     name = "FiraCode Nerd Font Mono Medium";
  #   };                                        # Cursor is declared under home.pointerCursor
  # };


  # # nextcloud sync
  # systemd.user = {
  #   services.nextcloud-autosync = {
  #     Unit = {
  #       Description = "Auto sync Nextcloud";
  #       After = "network-online.target";
  #     };
  #     Service = {
  #       Type = "simple";
  #       ExecStart= "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -n --path /Documents/Org /home/${user}/.org https://nextcloud.l.nervasion.com";
  #       TimeoutStopSec = "180";
  #       KillMode = "process";
  #       KillSignal = "SIGINT";
  #     };
  #     Install.WantedBy = ["multi-user.target"];
  #   };
  #   timers.nextcloud-autosync = {
  #     Unit.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 60 minutes";
  #     Timer.OnUnitActiveSec = "60min";
  #     Install.WantedBy = ["multi-user.target" "timers.target"];
  #   };
  #   startServices = true;
  # };


  # systemd.user.targets.tray = {               # Tray.target can not be found when xsession is not enabled. This fixes the issue.
  #   Unit = {
  #     Description = "Home Manager System Tray";
  #     Requires = [ "graphical-session-pre.target" ];
  #   };
  # };
}
