#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./editors
#       │   └─ default.nix
#       └─ ./shell
#           └─ default.nix
#

{ config, lib, pkgs, inputs, agenix, system, profile, location, u, hostname, ... }:

{
  imports = [
    #../modules/editors/emacs/doom-emacs          # Native doom emacs instead of nix-community flake
    # Native doom emacs instead of nix-community flake
    ../modules/cachix
    ../shared/dev.nix
  ];


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  console = {
    font = "Lat2-Terminus16";
    keyMap = "us"; # or us/azerty/etc
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;
  #sound = {                                # Deprecated due to pipewire
  #  enable = true;
  #  mediaKeys = {
  #    enable = true;
  #  };
  #};


  networking = {
    #computerName = "${hostname}";             # Host name
    hostName = "${hostname}";
  };

  environment = {
    variables = {
      TERMINAL = "alacritty";
    };
    sessionVariables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_STATE_HOME = "$HOME/.local/state";

    };
    systemPackages = with pkgs; [
      # Default packages installed system-wide
      agenix.packages."${stdenv.hostPlatform.system}".default
    ];
  };

  services = {
    qemuGuest.enable = true; # qemu guest agent
    # printing = {                                # Printing and drivers for TS5300
    #   enable = true;
    #   #drivers = [ pkgs.cnijfilter2 ];          # There is the possibility cups will complain about missing cmdtocanonij3. I guess this is just an error that can be ignored for now. Also no longer need required since server uses ipp to share printer over network.
    # };
    # avahi = {                                   # Needed to find wireless printer
    #   enable = true;
    #   nssmdns = true;
    #   publish = {                               # Needed for detecting the scanner
    #     enable = true;
    #     addresses = true;
    #     userServices = true;
    #   };
    # };
    # pipewire = {                            # Sound
    #   enable = false;
    #   alsa = {
    #     enable = true;
    #     support32Bit = true;
    #   };
    #   pulse.enable = true;
    #   jack.enable = true;
    # };
    openssh = {
      # SSH: secure shell (remote connection to shell of server)
      enable = true; # local: $ ssh <user>@<ip>
      # public:
      #   - port forward 22 TCP to server
      #   - in case you want to use the domain name insted of the ip:
      #       - for me, via cloudflare, create an A record with name "ssh" to the correct ip without proxy
      #   - connect via ssh <user>@<ip or ssh.domain>
      # generating a key:
      #   - $ ssh-keygen   |  ssh-copy-id <ip/domain>  |  ssh-add
      #   - if ssh-add does not work: $ eval `ssh-agent -s`
      allowSFTP = false; # SFTP: secure file transfer protocol (send file to server)
      # connect: $ sftp <user>@<ip/domain>
      #   or with file browser: sftp://<ip address>
      # commands:
      #   - lpwd & pwd = print (local) parent working directory
      #   - put/get <filename> = send or receive file
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      ''; # Temporary extra config so ssh will work in guacamole
    };
    #flatpak.enable = true;                  # download flatpak file from website - sudo flatpak install <path> - reboot if not showing up
    # sudo flatpak uninstall --delete-data <app-id> (> flatpak list --app) - flatpak uninstall --unused
    # List:
    # com.obsproject.Studio
    # com.parsecgaming.parsec
    # com.usebottles.bottles
  };

  nix = {
    # Nix Package Manager settings
    #package = pkgs.nixVersions.unstable;    # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    gc.dates = "daily";

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };


  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit profile u; };
    users.${profile.user}.imports = builtins.trace "activating the home nix" [
      ../shared/home.nix
      ./vm/home.nix
    ];

  };

  system = {
    # NixOS settings
    autoUpgrade = {
      # Allow auto update (not useful in flakes)
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "23.11";
  };

}
