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

{ config, pkgs, profile, vmid, ... }:

let

in
{
  imports =
    [ (import ./hardware-configuration.nix) ] ++ # Current system hardware config
    [ ];

  boot = {
    # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      # For legacy boot
      grub = {
        enable = true;
        device = "/dev/sda"; # Name of hard drive (can also be vda)
      };
    };
  };
  environment = {
    # Packages installed system wide
    systemPackages = with pkgs; [
      # This is because some options need to be configured.
      #discord
      #plex
      #simple-scan
      #x11vnc
      #wacomtablet
      #clinfo
    ]; #++ (profile.additionalPackages { pkgs = pkgs;});
    #variables = {
    #  LIBVA_DRIVER_NAME = "i965";
    #};
  };
  system.stateVersion = "23.11";
  programs.zsh.enable = true;

  #config.system.nixos.label="guivm";
  proxmox = {
    qemuConf = {
      # essential configs
      boot = "order=virtio0";
      scsihw = "virtio-scsi-pci";
      virtio0 = "local-lvm:vm-${vmid}-disk-0";
      net0 = "virtio=66:f8:21:f9:08:d4,bridge=vmbr0,firewall=1";
      ostype = "l26";
      cores = 4;
      memory = 8192;
      bios = "seabios";

      # optional configs
      #additionalSpace = "512M";
      #diskSize = "auto";
      agent = true;
    };
  };

  services.cloud-init = {
    enable = true;
    network.enable = true;
  };

  users.users.${profile.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" ];
    shell = pkgs.zsh;
    uid = 1001;
    hashedPassword = profile.hashedPassword;
  };
  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.


}
