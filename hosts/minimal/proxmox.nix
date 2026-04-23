{ config, pkgs, u, hostname, lib, inputs, vmconf, ... }:
let
  hostname-gen = import ../../utils/mac_id_from_hostname.nix;
  vmid = u.getOrDefault vmconf "vmid" "111";
  cores = u.getOrDefault vmconf "cores" 8;
  memory = u.getOrDefault vmconf "memory" (48*1024);
  ether = u.getOrDefault vmconf "ether" (hostname-gen hostname);
  additionalSpace = u.getOrDefault vmconf "additionalSpace" "2G";
in 
{

  # imports = [
  #   # ... other imports
  #   (inputs.nixpkgs + "/nixos/modules/virtualisation/proxmox-image.nix")
  # ];  
  proxmox = {
    qemuConf = {
      # essential configs
      boot = "order=virtio0";
      scsihw = "virtio-scsi-pci";
      virtio0 = "local-lvm:vm-${vmid}-disk-0";
      net0 = "virtio=${ether},bridge=vmbr0,firewall=1";
      ostype = "l26";
      cores = cores;
      memory = memory;
      bios = "seabios";

      # optional configs
      additionalSpace = additionalSpace;
      agent = true;
    };
  };
  virtualisation = {
    diskSize = "auto";

  };

}
