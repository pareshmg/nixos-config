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
  imports = [
    # For now, if applying to other system, swap files
    ../basedev/default.nix
    ./hardware-configuration.nix # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    ./timers.nix
    #../../modules/desktop/bspwm/default.nix     # Window Manager
  ];

  boot = {
    # Boot options
    kernelPackages = pkgs.linuxPackages_hardened;

    loader = {
      # For legacy boot
      grub = {
        enable = true;
        device = "/dev/sda"; # Name of hard drive (can also be vda)
      };
      timeout = 1; # Grub auto select timeout
    };
  };
  services.logrotate.checkConfig = false;

  users.users.${profile.user} = {
    # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "docker" "podman" "users" ];
    uid = 1000;
  };
  users.groups.${profile.user} = {
    name = "${profile.user}";
    members = [ "${profile.user}" ];
    gid = 1000;
  };
  security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.

  ### container virtualization:
  ## docker
  virtualisation.docker = {
    enable = true;
    #enableNvidia = true;
    autoPrune.enable = true;
  };

  hardware.nvidia-container-toolkit.enable = true;
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
      kubernetes-helm
      k9s
      nfs-utils
      nvtopPackages.full
      google-authenticator
      # cloud-utils # growpart
      #nvidia-podman
      #nvidia-docker
      nix-serve
    ];
  };


  # age = {
  #   secrets = {
  #     nextcloud_davfs = {
  #       file = secrets.per.nextcloud_davfs;
  #       owner = "root";
  #       mode = "600";
  #       symlink = false;
  #     };
  #   };
  #   identityPaths = profile.identityPaths;
  # };


  # Make sure opengl is enabled
  hardware = {
    graphics = {
      enable = true;
      #driSupport = true;
      enable32Bit = true;
    };

  };
  services.xserver.videoDrivers = [ "nvidia" ];



  ## TEST

  systemd.services.nix-serve = {
    enable = true;
    description = "NixBinaryCache";
    #path = [ pkgs.nix-serve ];
    after = [ "default.target" ];
    serviceConfig = {
      User = profile.user;
      ExecStart = "${pkgs.nix-serve}/bin/nix-serve -l :5000";
    };
  };


}
