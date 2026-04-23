{ config, pkgs, ... }:

let
  nfsPath = "nfs.l.nervasion.com:/mnt/nas/nixbuild";
in
{
  # Ensure NFS support utilities are installed in the image
  boot.supportedFilesystems = [ "nfs" ];
  environment.systemPackages = [ pkgs.nfs-utils ];

  fileSystems."/etc/nervasion/nixbuild" = {
    device = nfsPath; # Replace with your NFS Server IP and Path
    fsType = "nfs";
    options = [
      "ro"         # Match the server's 'ro'
      "nolock"     # Often needed for simple RO mounts to avoid locking overhead
      "soft"       # Prevents the VM from hanging forever if the NAS goes down      
      "_netdev" # Tells systemd to wait for network
      "nfsvers=4.2"                # Optional: Force a specific version to avoid handshake delays
    ];
    noCheck = true;
  };

  systemd = {
    services = {
      agenix-install = {
        # This ensures the NFS mount unit is started before agenix tries to run
        after = [ "etc-nervasion-nixbuild.mount" ]; 
        requires = [ "etc-nervasion-nixbuild.mount" ];
      };
      k3s = {
        after = [ "agenix-install.service" ];
        wants = [ "agenix-install.service" ];
      };
    };
    mounts = [{
      where = "/etc/nervasion/nixbuild";
      what = nfsPath;
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      mountConfig = {
        TimeoutSec = "30s";
      };
    }];
  };

  age.identityPaths = [ "/etc/nervasion/nixbuild/nixbuild_id_ed25519" ];
  
}
