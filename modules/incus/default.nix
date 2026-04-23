{ config, pkgs, ... }:

{
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 8443 ];
  networking.firewall.trustedInterfaces = [ "incusbr0" ];

  # networking.nftables.enable = true; # Ensure nftables is used if needed, but usually default implies iptables or nftables compat.
}
