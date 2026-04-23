#
# KDE Plasma 5 configuration
#

{ config, lib, pkgs, ... }:

{
  programs = {
    zsh.enable = true;
    # dconf.enable = true;
    # kdeconnect = {                                # For GSConnect
    #   enable = true;
    #   package = pkgs.gnomeExtensions.gsconnect;
    # };
  };

  services = {
    xserver = {
      enable = true;

      layout = "us"; # Keyboard layout & €-sign
      #xkbOptions = "eurosign:e";
      libinput.enable = true;
      modules = [ pkgs.xf86_input_wacom ]; # Both needed for wacom tablet usage
      wacom.enable = true;

      displayManager = {
        sddm.enable = true; # Display Manager
        #defaultSession = "plasmawayland";
      };
      desktopManager.plasma5 = {
        enable = true; # Desktop Manager
      };
    };
    xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
      openFirewall = true;
    };
  };

  #hardware.pulseaudio.enable = false;

  environment = {
    systemPackages = with pkgs.libsForQt5; [
      # Packages installed
      #packagekit-qt
      #bismuth
    ];
    plasma5 = {
      excludePackages = with pkgs.libsForQt5; [
        ark
        elisa
        gwenview
        okular
        khelpcenter
        print-manager
        konsole
        oxygen
      ];
    };
  };
}
