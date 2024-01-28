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

{ config, pkgs, inputs, user, ... }:

{
  imports = [
    # For now, if applying to other system, swap files
    ./hardware-configuration.nix # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    #../../modules/desktop/bspwm/default.nix     # Window Manager
  ];

  boot = {
    # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      # For legacy boot
      grub = {
        enable = true;
        device = "/dev/sda"; # Name of hard drive (can also be vda)
      };
      timeout = 1; # Grub auto select timeout
    };
  };

  users.users.${user} = {
    # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "docker" "podman" ];
    shell = pkgs.zsh; # Default shell
    uid = 1000;
  };
  users.groups.${user} = {
    name = "${user}";
    members = [ "${user}" ];
    gid = 1000;
  };
  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.

  environment = {
    systemPackages = with pkgs; [
      pciutils
      usbutils
      wget
      cloud-utils # growpart
      cloudflared
      #nvidia-podman
      #nvidia-docker
    ];
  };

  programs.zsh.enable = true;

  services.cloudflared = {
    enable = true;
    tunnels = {
      "00000000-0000-0000-0000-000000000000" = {
        credentialsFile = "${config.sops.secrets.cloudflared-creds.path}";
        ingress = {
          "*.domain1.com" = {
            service = "http://localhost:80";
            path = "/*.(jpg|png|css|js)";
          };
          "*.domain2.com" = "http://localhost:80";
        };
        default = "http_status:404";
      };
    };
  };

}
