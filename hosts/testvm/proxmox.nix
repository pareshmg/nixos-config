{ vmid, ... }:

{
  proxmox = {
    qemuConf = {
      # essential configs
      #boot = "order=virtio0";
      #scsihw = "virtio-scsi-pci";
      virtio0 = "local-lvm:vm-${vmid}-disk-0";
      #net0 = "virtio=66:f8:21:f9:08:d4,bridge=vmbr0,firewall=1";
      ostype = "l26";
      cores = 4;
      memory = 8192;
      #bios = "seabios";

      # optional configs
      additionalSpace = "2048M";
      diskSize = "auto";
      agent = true;
    };
  };


}
