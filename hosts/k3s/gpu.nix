{ config, lib, pkgs, ... }:

{

  # 1. Enable NVIDIA Drivers
  services.xserver = {
    enable = false;
    videoDrivers = [ "nvidia" ];
  };
  

  hardware = {
    nvidia = {
      open = true; 

      # Ensure these are also set for your 3090
      modesetting.enable = true;
      powerManagement.enable = false; # Set to true if you experience suspend/resume issues
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      nvidiaSettings = true;
    };
    nvidia-container-toolkit = {
      enable = true;
      mount-nvidia-executables = true;
      mount-nvidia-docker-1-directories = true;
    };
  };

  # 3. K3s Setup
  services.k3s = {
    enable = true;
    # Point K3s to a custom containerd config template
    containerdConfigTemplate = "/etc/rancher/k3s/config.toml.tmpl";
    
    # Tell K3s to use the NVIDIA runtime we configured in the template
    extraFlags = [
      "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
      # # Optional: Only allow pods that EXPLICITLY ask for a GPU to run here
      # "--node-taint dedicated=gpu:NoSchedule"
    ];
  };

  # # 1. Provide the containerd template file to K3s
  # # This file defines the 'nvidia' runtime class
  # environment.etc."rancher/k3s/config.toml.tmpl".text = ''
  #   [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
  #     runtime_type = "io.containerd.runc.v2"
  #   [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.options]
  #     BinaryName = "/run/current-system/sw/bin/nvidia-container-runtime"
  # '';

  environment.systemPackages = with pkgs; [
    containerd
    nvidia-container-toolkit
    libnvidia-container
  ];
  systemd = {
  #   tmpfiles.rules = [
  #     "L+ /opt/cni/bin - - - - /var/lib/rancher/k3s/data/current/bin"
  #     "L+ /etc/cni/net.d - - - - /var/lib/rancher/k3s/agent/etc/cni/net.d"
  #   ];
  #   services.containerd.path = [ pkgs.containerd pkgs.runc ];
    tmpfiles.rules = [
      # 1. Map the NixOS GL driver path to the standard Ubuntu path the toolkit expects
      "L+ /usr/lib/x86_64-linux-gnu - - - - /run/opengl-driver/lib"
      
      # 2. Map the 32-bit drivers (sometimes required for toolkit initialization)
      "L+ /usr/lib/i386-linux-gnu - - - - /run/opengl-driver-32/lib"

      # 3. Create a link for the NVIDIA management library specifically
      "L+ /usr/lib64 - - - - /run/opengl-driver/lib"
    ];
  };


  
  virtualisation.containerd = {
    enable = true;
    settings = {
      # CNI bin_dir to the CRI plugin configuration      
      plugins."io.containerd.grpc.v1.cri".cni = {
        bin_dir = "/var/lib/rancher/k3s/data/current/bin";
        conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d";
      };
              
      plugins."io.containerd.grpc.v1.cri".containerd = {
        no_pivot = false;
        default_runtime_name = "nvidia";

        runtimes.nvidia = {
          runtime_type = "io.containerd.runc.v2";
          #runtime_type = "io.containerd.runtime.nvidia.v1";
          runtime_path = "${pkgs.containerd}/bin/containerd-shim-runc-v2";
          options = {
            BinaryName = "${pkgs.runc}/bin/runc";
            SystemdCgroup = true;
          };
        };
      };
    };
  };

  # This creates the config file the toolkit uses to find your GPU libraries
  environment.etc."nvidia-container-runtime/config.toml".text = ''
  disable-require = false
  # debug = "/var/log/nvidia-container-toolkit.log"

  [nvidia-container-cli]
  # Point this to the actual binary in the nix store
  path = "${pkgs.libnvidia-container}/bin/nvidia-container-cli"
  environment = []
  # This is the critical line for NixOS
  ldconfig = "/run/current-system/sw/bin/ldconfig"
  load-kmods = true
  no-cgroups = false
  user = "root:video"

  [nvidia-container-runtime]
  debug = "/var/log/nvidia-container-runtime.log"
'';
  
  
  # Allow unfree software (NVIDIA drivers)
  nixpkgs.config.allowUnfree = true;
}
