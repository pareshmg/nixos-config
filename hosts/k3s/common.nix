{ config, lib, pkgs, ... }:

with lib;

let
  # A common convention is to create a shorter alias for the module's specific config path
  cfg = config.services.k3s-cluster;
in
{
  # 1. Declare what settings a user of this module can set
  options.services.k3s-cluster = {
    enable = mkEnableOption "Enable k3s service";
    k3sTokenAgeFile = mkOption {
      type = types.path; # Enforces the value to be a nix store path
      description = "The age k3s token file token you want to use.";
    };

    clusterIp = mkOption {
      type = types.str; # Enforces the value to be ipv4
      example = "10.0.0.100";
      description = "The main cluster IP to provision.";
    };

    ipPrefixLength = mkOption {
      type = types.int; # Enforces the value to be an int
      example = 14;
      description = "The base mask .";
    };

    machineMode = lib.mkOption {
      # The enum type takes a list of allowed values
      type = lib.types.enum [ "first-server" "server" "worker" ];
      
      default = "server";
      description = "The type of k3s machine init it is.";
    };    
    
    serverIps = lib.mkOption {
      # Use listOf to allow multiple entries
      type = lib.types.listOf lib.types.str; 
      
      example = [ "10.0.1.1" "10.0.1.2" ];
      description = "A list of IPv4 server addresses to HAProxy load balance.";
    };
  };

  # 2. Define what other settings/resources should be active based on the options
  config = mkIf cfg.enable {
    # 1. HAProxy: Routes traffic from port 6443 to the actual k3s API
    services = {
      haproxy = {
        enable = true;
        config = ''
      frontend k3s-frontend
        bind *:6443
        mode tcp
        option tcplog
        default_backend k3s-backend

      backend k3s-backend
        mode tcp
        option tcp-check
        balance roundrobin
        ${pkgs.lib.concatStringsSep "\n" (map (ip: "server node-${ip} ${ip}:6444 check") cfg.serverIps)}
    '';
      };

      # 2. Keepalived: Manages the Virtual IP (VIP)
      keepalived = {
        enable = true;
        vrrpInstances.k3s = {
          state = "BACKUP"; # Set to MASTER on one node, BACKUP on others
          interface = "eth0"; # Change to your actual network interface
          virtualRouterId = 51;
          priority = 100; # Higher number wins (e.g., 101 on MASTER)
          virtualIps = [ { addr = "${cfg.clusterIp}/${toString cfg.ipPrefixLength}"; } ];
        };
      };

      k3s = lib.mkMerge [
        ({
          enable = true;
        })
        
        (lib.mkIf (cfg.machineMode == "first-server") {
          role = "server";
          clusterInit = true;
          extraFlags = "--tls-san ${cfg.clusterIp} --https-listen-port 6444";
        })
        
        (lib.mkIf (cfg.machineMode == "server") {
          role = "server";
          serverAddr = "https://${cfg.clusterIp}:6443";
          tokenFile = "/var/lib/rancher/k3s/server/node-token";
          extraFlags = "--https-listen-port 6444";
        })

        (lib.mkIf (cfg.machineMode == "worker") {
          role = "agent";
          serverAddr = "https://${cfg.clusterIp}:6443";
          tokenFile = "/var/lib/rancher/k3s/server/node-token";
          # Extra flags for agents
          extraFlags = [
            "--node-label=node-role.kubernetes.io/worker=true"
          ];
        })
      ];
      
    };
    # 3. Open Firewall Ports
    networking.firewall= {
      allowedTCPPorts = [
        6443
        6444
        8472 # Flannel VXLAN
        10250 # Kubelet metrics      
        51820 # If you ever switch to Flannel Wireguard backend
      ];
      allowedUDPPorts = [
        112
      ]; # VRRP protocol for Keepalived
      # Flannel needs to be able to route traffic between interfaces
      checkReversePath = false;    
    };

    age.secrets.k3s-token.file = cfg.k3sTokenAgeFile;
    
  };
}


