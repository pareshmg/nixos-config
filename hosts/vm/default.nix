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

{ config, pkgs, inputs, profile, agenix, secrets, ... }:

{
  imports =  [                                  # For now, if applying to other system, swap files
    ./hardware-configuration.nix                # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    #../../modules/desktop/bspwm/default.nix     # Window Manager
  ];

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_hardened;

    loader = {                                  # For legacy boot
      grub = {
        enable = true;
        device = "/dev/sda";                    # Name of hard drive (can also be vda)
      };
      timeout = 1;                              # Grub auto select timeout
    };
  };

  users.users.${profile.user} = {                   # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "docker" "podman" ];
    shell = pkgs.zsh;                       # Default shell
    uid = 1000;
  };
  users.groups.${profile.user} = {
    name = "${profile.user}";
    members = ["${profile.user}"];
    gid = 1000;
  };
  security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.

  ### container virtualization:
  ## docker
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    autoPrune.enable = true;
  };
  ## podman
  # virtualisation.podman = {
  #   enable = true;
  #   enableNvidia = true;
  #   autoPrune = {
  #     enable = true;
  #     flags = [
  #       "--all"
  #     ];
  #   };
  #   # Create a `docker` alias for podman, to use it as a drop-in replacement
  #   dockerCompat = false;
  #   # Required for containers under podman-compose to be able to talk to each other.
  #   defaultNetwork.settings = {
  #     dns_enabled = true;
  #   };
  # };


  environment = {
    systemPackages = with pkgs; [
      pciutils
      usbutils
      wget
      kubectl
      kubetail
      kubernetes-helm
      nfs-utils
      nvtop
      google-authenticator
      cloud-utils # growpart
      #nvidia-podman
      #nvidia-docker
    ];
  };


  age = {
    secrets = {
      nextcloud_davfs = {
        file = secrets.per.nextcloud_davfs;
        owner = "root";
        mode = "600";
        symlink = false;
      };
    };
    identityPaths = profile.identityPaths;
  };


  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  # services = {
  #   xserver = {
  #     resolutions = [
  #       { x = 1920; y = 1080; }
  #       { x = 1600; y = 900; }
  #       { x = 3840; y = 2160; }
  #     ];
  #   };
  # };
}
