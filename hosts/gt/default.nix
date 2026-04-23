{ config, pkgs, inputs, profile, agenix, secrets, ... }:

{
  imports = [
    ../basedev/default.nix
  ];

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
    autoPrune.enable = true;
  };



  environment = {
    systemPackages = with pkgs; [
      pciutils
      usbutils
      wget
      kubectl
      kubernetes-helm
      k9s
      nfs-utils
      # nvtopPackages.full
      google-authenticator
      # cloud-utils # growpart
      #nvidia-podman
      #nvidia-docker
      nix-serve
    ];
  };




}
