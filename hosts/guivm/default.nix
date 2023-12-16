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

{ config, pkgs, user, ... }:

let
  vmid="111";
in
{
  imports =
    [(import ./hardware-configuration.nix)] ++                # Current system hardware config
    [(import ../../modules/desktop/kde/default.nix)];  # window manager

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                                  # For legacy boot
      grub = {
        enable = true;
        device = "/dev/sda";                    # Name of hard drive (can also be vda)
      };
    };
  };
  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
      #discord
      #plex
      #simple-scan
      #x11vnc
      wacomtablet
      #clinfo
    ];
    #variables = {
    #  LIBVA_DRIVER_NAME = "i965";
    #};
  };

  #config.system.nixos.label="guivm";
  proxmox = {
    qemuConf = {
      # essential configs
      boot = "order=virtio0";
      scsihw = "virtio-scsi-pci";
      virtio0 = "local-lvm:vm-${vmid}-disk-0";
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

  users.users.guest = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "docker" "podman" ];
    shell = pkgs.zsh;
    uid = 1001;
    hashedPassword = "$6$fCX3BAFxKwT3RTpn$UOiEyAdVkKTbjvjHO6mhPp/aklM2Xgt857Blfq1sNZAU1xzczzwViqgzG5PlvGVRrC0hRtdGG4nFo0wvIBjCP/";
  };
  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        #intel-media-driver                     # iGPU
        #vaapiIntel
        #rocm-opencl-icd                         # AMD
        #rocm-opencl-runtime
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
  };

}
