#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   ├─ ./bspwm
#       │   │   └─ default.nix
#       │   └─ ./virtualisation
#       │       └─ docker.nix
#       └─ ./hardware
#           └─ default.nix
#

{ config, pkgs, user, ... }:

{
  imports = # For now, if applying to other system, swap files
    [ (import ./hardware-configuration.nix) ] ++ # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [ (import ../../modules/desktop/bspwm/default.nix) ] ++ # Window Manager
    [ (import ../../modules/desktop/virtualisation/docker.nix) ] ++ # Docker
    (import ../../modules/hardware); # Hardware devices

  boot = {
    # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      # EFI Boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        # Most of grub is set up for dual boot
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true; # Find all boot options
        configurationLimit = 2;
      };
      timeout = 1; # Grub auto select time
    };
  };

  hardware.sane = {
    # Used for scanning with Xsane
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  environment = {
    systemPackages = with pkgs; [
      simple-scan
    ];
  };

  programs = {
    # No xbacklight, this is the alterantive
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    tlp.enable = true; # TLP and auto-cpufreq for power management
    #logind.lidSwitch = "ignore";           # Laptop does not go to sleep when lid is closed
    auto-cpufreq.enable = true;
    blueman.enable = true;
    printing = {
      # Printing and drivers for TS5300
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];
    };
    avahi = {
      # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {
        # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    samba = {
      enable = true;
      shares = {
        share = {
          "path" = "/home/${user}";
          "guest ok" = "no";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
  };

  systemd = {
    #temporary bluetooth fix
    tmpfiles.rules = [
      "d /var/lib/bluetooth 700 root root - -"
    ];
    targets."bluetooth".after = [ "systemd-tmpfiles-setup.service" ];

    # disable coredump that could be exploited later
    # and also slow down the system when something crash
    coredump.enable = false;
  };

  ##################################################
  ### Hardening
  ### https://dataswamp.org/~solene/2022-01-13-nixos-hardened.html

  # enable firewall and block all ports
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # required to run chromium
  security.chromiumSuidSandbox.enable = true;

  # enable firejail
  programs.firejail.enable = true;

  # create system-wide executables firefox and chromium
  # that will wrap the real binaries so everything
  # work out of the box.
  programs.firejail.wrappedBinaries = {
    firefox = {
      executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    };
    chromium = {
      executable = "${pkgs.lib.getBin pkgs.chromium}/bin/chromium";
      profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
    };
  };

  # enable antivirus clamav and
  # keep the signatures' database updated
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  ##################################################

}
