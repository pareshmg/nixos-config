#
# Hardware settings for a general VM.
# Works on QEMU Virt-Manager and Virtualbox
#
# flake.nix
#  └─ ./hosts
#      └─ ./vm
#          └─ hardware-configuration.nix *
#
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
#

{ config, lib, pkgs, modulesPath, profile, u, ... }:
let
  user = profile.user;
in
{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # zfs
  # boot.supportedFilesystems = [ "zfs" ];
  # services.zfs = {
  #   autoScrub.enable = true;
  #   trim.enable = true;
  # };

  hardware.nvidia = {

    # Modesetting is needed for most wayland compositors
    modesetting.enable = false;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
    # powerManagement.finegrained = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = false;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/7e38979e-68c7-466c-b8b7-db7b979841cd";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/09ad8c4c-f140-494b-9277-37f46ab0c157";
      fsType = "xfs";
    };
  # fileSystems."/var/lib/docker" =
  #   { device = "/dev/disk/by-uuid/049a8269-2f23-48d1-8381-38db88c0459b";
  #     fsType = "ext4";
  #   };
  fileSystems."/mnt/cache" =
    { device = "/dev/disk/by-uuid/6e7e9cce-524d-41cc-8507-e1e8a57f4de4";
      fsType = "ext4";
    };
  fileSystems."/media/pvenfs" = {
    device = "nfs.l.nervasion.com:/mnt/nas/orya";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };
  fileSystems."/home/${user}/.org" = {
    device = "nfs.l.nervasion.com:/mnt/nas/nextcloud/localstorage/Org";
    fsType = "nfs";
    options = [ "x-systemd.automount" "user" "noauto" ];
    #options = [ "x-systemd.automount" "user,noauto,soft,intr,rsize=8192,wsize=8192,timeo=900,retrans=3,proto=tcp,all_squash,anonuid=0,anongid=0" ];
    #options = [ "x-systemd.automount" "user,noauto"];
  };


  # services.davfs2.enable = true;
  # fileSystems."/media/nextcloud" = {
  #   device = "https://nextcloud.l.nervasion.com/remote.php/dav/files/pareshmg/Documents/Org/";
  #   fsType = "davfs";
  #   options = let
  #     davfs2Conf = (pkgs.writeText "davfs2.conf" "secrets ${config.age.secrets.per.nextcloud_davfs.path}");
  #   in [ "conf=${davfs2Conf}" "x-systemd.automount" "user,uid=1000,gid=1000,noauto"];
  # };

  # fileSystems."/media/org" = {
  #   device = "nfs.l.nervasion.com:/mnt/nas/nextcloud/data/pareshmg/files/Documents/Org";
  #   fsType = "nfs";
  #   options = [ "x-systemd.automount" "noauto" "user" ];
  # };


  swapDevices = [ ];


  #networking.useDHCP = lib.mkDefault true;
  networking = u.recursiveMerge [
    {
      useDHCP = false;                        # Deprecated
      hostId = profile.macAddress;
      interfaces = {
          ens18 = {
            ipv4.addresses = [ {
              address = profile.ip;
              prefixLength = 16;
            } ];
          };
      };
    }
    (u.getOrDefault profile "networking" {})
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  #hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  #virtualisation.virtualbox.guest.enable = true;     #currently disabled because package is broken
  #powerManagement.cpuFreqGovernor = "performance"
}
