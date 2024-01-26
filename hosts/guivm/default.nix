{ config, pkgs, profile, vmid, ... }:

let
  user = profile.user;
in
{
  imports =
    [(import ../../modules/profiles/hardened.nix)] ++
    [(import ./hardware-configuration.nix)] ++                # Current system hardware config
    [(import ../../modules/desktop/hyprland/default.nix)];  # window manager

  boot = {                                      # Boot options
    loader = {                                  # For legacy boot
      grub = {
        enable = true;
        device = "/dev/sda";                    # Name of hard drive (can also be vda)
      };
    };
  };

  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
      #simple-scan
      wacomtablet
      #clinfo
    ] ++ (profile.additionalPackages { pkgs = pkgs;});
    #variables = {
    #  LIBVA_DRIVER_NAME = "i965";
    #};
  };

  system.stateVersion = "23.11";

  #config.system.nixos.label="guivm";
  proxmox = {
    qemuConf = {
      # essential configs
      boot = "order=virtio0";
      scsihw = "virtio-scsi-pci";
      virtio0 = "local-lvm:vm-${vmid}-disk-0";
      net0 = "virtio=66:f8:21:f9:08:d3,bridge=vmbr0,firewall=1";
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

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["video" "audio" "networkmanager" "lp"  "kvm" "libvirtd" ];
    shell = pkgs.zsh;
    uid = 1001;
    hashedPassword = profile.hashedPassword;
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.

  home-manager = {
    users.${user} = {
      imports = [(import ./home.nix)];
    };
  };

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
