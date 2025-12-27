#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./vm
#   │       ├─ default.nix *
#   │       └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ bspwm.nix
#

{ config, lib, pkgs, profile, vmid, ... }:

{
  services.logrotate.checkConfig = false;
  imports = [
    ./hardware-configuration.nix
  ];

  # boot = {
  #   # Boot options
  #   kernelPackages = pkgs.linuxPackages_latest;

  #   loader = {
  #     # For legacy boot
  #     grub = {
  #       enable = true;
  #       device = "/dev/sda"; # Name of hard drive (can also be vda)
  #     };
  #   };
  # };
  # environment = {
  #   # Packages installed system wide
  #   systemPackages = with pkgs; [
  #     # This is because some options need to be configured.
  #     #discord
  #     #plex
  #     #simple-scan
  #     #x11vnc
  #     #wacomtablet
  #     #clinfo
  #   ]; #++ (profile.additionalPackages { pkgs = pkgs;});
  #   #variables = {
  #   #  LIBVA_DRIVER_NAME = "i965";
  #   #};
  # };
  system.stateVersion = "23.11";
  programs.zsh.enable = true;


  # user configuration
  users.users.${profile.user} = {
    isNormalUser = true;
    extraGroups = [
      "video"
      "audio"
      "networkmanager"
      "lp"
      "kvm"
      "libvirtd"
      "docker"
      "dialout" # for zwave ttyACM0
    ];
    shell = pkgs.zsh;
    #uid = 1001;
    inherit (profile) hashedPassword;
  };
  security.sudo.wheelNeedsPassword = lib.mkDefault true; # User does not need to give password when using sudo.


}
