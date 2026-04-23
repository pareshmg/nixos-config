{ config, pkgs, ... }:

{
  # QEMU Guest Agent is required for Incus to communicate with the VM (get IP, shutdown, etc.)
  services.qemuGuest.enable = true;

  # Incus provides networking via DHCP usually
  networking.useDHCP = true;

  # Ensure serial console is available for `incus console`
  boot.kernelParams = [ "console=ttyS0" ];
}
