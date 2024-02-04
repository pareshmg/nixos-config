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

{ config, lib, pkgs, profile, u, vmid, hostname, modulesPath, ... }:

let

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


  # fileSystems."/" =
  #   { device = "/dev/disk/by-uuid/7e38979e-68c7-466c-b8b7-db7b979841cd";
  #     fsType = "ext4";
  #   };

  # fileSystems."/home" =
  #   { device = "/dev/disk/by-uuid/09ad8c4c-f140-494b-9277-37f46ab0c157";
  #     fsType = "xfs";
  #   };
  # # fileSystems."/var/lib/docker" =
  # #   { device = "/dev/disk/by-uuid/049a8269-2f23-48d1-8381-38db88c0459b";
  # #     fsType = "ext4";
  # #   };
  # fileSystems."/mnt/cache" =
  #   { device = "/dev/disk/by-uuid/6e7e9cce-524d-41cc-8507-e1e8a57f4de4";
  #     fsType = "ext4";
  #   };
  # fileSystems."/media/pvenfs" = {
  #   device = "nfs.l.nervasion.com:/mnt/nas/orya";
  #   fsType = "nfs";
  #   options = [ "x-systemd.automount" "noauto" ];
  # };



  swapDevices = [ ];


  networking = u.recursiveMerge [
    {
      useDHCP = true; # Deprecated
      hostId = profile.macAddress;
      interfaces = {
        ens18 = {
          ipv4.addresses = [{
            address = profile.ip;
            prefixLength = 16;
          }];
        };
      };
    }
    (u.getOrDefault profile "networking" { })
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  #hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  #virtualisation.virtualbox.guest.enable = true;     #currently disabled because package is broken
  #powerManagement.cpuFreqGovernor = "performance"
}