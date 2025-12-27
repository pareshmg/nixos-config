{ config, lib, pkgs, vmid, ... }:

{
  proxmox = {
    qemuConf = {
      # essential configs
      #boot = "order=virtio0";
      #scsihw = "virtio-scsi-pci";
      virtio0 = "local-lvm:vm-${vmid}-disk-0";
      net0 = "virtio=BC:24:11:CC:2C:81,bridge=vmbr0,firewall=1";
      ostype = "l26";
      cores = 4;
      memory = 8192;
      #bios = "seabios";

      # optional configs
      additionalSpace = "20480M";
      diskSize = "auto";
      agent = true;
    };
  };

}
