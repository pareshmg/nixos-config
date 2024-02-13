{ config, pkgs, profile, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./greetd.nix
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
        experimental-features = nix-command flakes
    '';
  };

  # boot.loader = {
  #   grub = {
  #     enable = true;
  #     device = "nodev";
  #     efiSupport = true;
  #   };
  #   efi = {
  #     canTouchEfiVariables = true;
  #     efiSysMountPoint = "/boot";
  #   };
  # };

  networking = {
    networkmanager.enable = true;
    #hostName = "testvm"; # edit this to your liking
  };

  # QEMU-specific
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # locales
  # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # wayland-related
  # programs.sway.enable = true; # commented out due to usage of home-manager's sway
  security.polkit.enable = true;
  hardware.opengl.enable = true; # when using QEMU KVM

  # audio
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;

  # ssh
  services.openssh = {
    enable = false;
    settings = {
      #kexAlgorithms = [ "curve25519-sha256" ];
      #ciphers = [ "chacha20-poly1305@openssh.com" ];
      #passwordAuthentication = false;
      #permitRootLogin = "no"; # do not allow to login as root user
      #kbdInteractiveAuthentication = false;
    };
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    #dejavu_fonts # mind the underscore! most of the packages are named with a hypen, not this one however
    #noto-fonts
    #noto-fonts-cjk
    #noto-fonts-emoji
  ];


  # installed packages
  environment.systemPackages = with pkgs; [
    # cli utils
    git
    curl
    wget
    foot
  ] ++ (profile.additionalPackages { inherit pkgs;});


  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit profile; };
    users.${profile.user}.imports = [./home.nix];
  };


  system.stateVersion = "23.11";
}
