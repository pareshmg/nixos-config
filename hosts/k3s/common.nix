{ config, lib, pkgs, profile, u, secrets, sshKeyContent, ... }:

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

    nodeIp = mkOption {
      type = types.str; # Enforces the value to be ipv4
      example = "10.0.0.100";
      description = "IP of the node we are creating.";
    };

    ipPrefixLength = mkOption {
      type = types.int; # Enforces the value to be an int
      example = 16;
      default=16;
      description = "The base mask .";
    };

    machineMode = lib.mkOption {
      # The enum type takes a list of allowed values
      type = lib.types.enum [ "first-server" "server" "worker" ];
      description = "The type of k3s machine init it is.";
    };    
    
    nodeName = lib.mkOption {
      # The enum type takes a list of allowed values
      type = types.str;
      description = "Node name.";
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
    assertions = [{
      assertion = sshKeyContent != "";
      message = "You must set the SSH_HOST_KEY environment variable to build this VM!";
    }];

    # support nfs
    boot.supportedFilesystems = [ "nfs" ];
    
    # 1. HAProxy: Routes traffic from port 6443 to the actual k3s API
    services = {
      openssh = {
        enable = true;
        hostKeys = [
          {
            path = config.age.secrets.ssh_host_ed25519_key.path;
            type = "ed25519";
          }
          {
            path = config.age.secrets.ssh_host_rsa_key.path;
            type = "rsa";
            bits = 4096;
          }
        ];        
      };

      haproxy = {
        enable = (cfg.machineMode == "first-server" || cfg.machineMode == "server");
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

      frontend http-frontend
        bind *:80
        mode tcp
        option tcplog
        default_backend http-backend

      backend http-backend
        mode tcp
        option tcp-check
        balance roundrobin
        ${pkgs.lib.concatStringsSep "\n" (map (ip: "server node-${ip} ${ip}:80 check") cfg.serverIps)}

      frontend https-frontend
        bind *:443
        mode tcp
        option tcplog
        default_backend https-backend

      backend https-backend
        mode tcp
        option tcp-check
        balance roundrobin
        ${pkgs.lib.concatStringsSep "\n" (map (ip: "server node-${ip} ${ip}:443 check") cfg.serverIps)}


      # Frontend for gitea NodePort 30007
      frontend nodeport-30007-frontend
        bind *:30007
        mode tcp
        option tcplog
        default_backend nodeport-30007-backend

      backend nodeport-30007-backend
        mode tcp
        option tcp-check
        balance roundrobin
        # Note: We send traffic to 30007 on the worker nodes
        ${pkgs.lib.concatStringsSep "\n" (map (ip: "server node-${ip} ${ip}:30007 check") cfg.serverIps)}
    '';
      };

      # 2. Keepalived: Manages the Virtual IP (VIP)
      keepalived = {
        enable = (cfg.machineMode == "first-server" || cfg.machineMode == "server");
        vrrpInstances.k3s = {
          state = if (cfg.machineMode == "first-server") then "MASTER" else "BACKUP"; # Set to MASTER on one node, BACKUP on others
          interface = "ens18"; # Change to your actual network interface
          virtualRouterId = 51;
          priority = if (cfg.machineMode == "first-server") then 101 else 100; # Higher number wins (e.g., 101 on MASTER)
          virtualIps = [ { addr = "${cfg.clusterIp}/${toString cfg.ipPrefixLength}"; } ];
        };
      };

      # for longhorn
      openiscsi = {
        enable = true;
        name = "iqn.2026-03.com.nervasion:${cfg.nodeName}"; # Unique initiator name
      };


      k3s = builtins.trace ("DEBUG: machineMode is " + cfg.machineMode) (lib.mkMerge [
        ({
          enable = true;
          nodeName = cfg.nodeName;
          tokenFile = "/etc/k3s-node-token";
          extraFlags = [
            "--node-ip=${cfg.nodeIp}"
          ];
        })

        (lib.mkIf (cfg.machineMode == "server") {
          serverAddr = "https://${cfg.clusterIp}:6443";
        })
        
        (lib.mkIf (cfg.machineMode == "server" || cfg.machineMode == "first-server") {
          role = "server";
          serverAddr = "https://${cfg.clusterIp}:6443";
          extraFlags =  [
            "--tls-san ${cfg.clusterIp}"
            "--https-listen-port 6444"
            "--disable=traefik"
            "--advertise-address=${cfg.nodeIp}"
          ];
        })

        
        (lib.mkIf (cfg.machineMode == "worker") {
          role = "agent";
          serverAddr = "https://${cfg.clusterIp}:6443";
          # Extra flags for agents
          extraFlags = [
            # any flags here
          ];
        })
      ]);

      rpcbind.enable = true; # Necessary for NFSv3/v4
    };


    systemd = {
      tmpfiles.rules = [
        "d /var/lib/rancher/k3s/server/tls 0700 root root -"
      ];
      services = {
        k3s = {
          # Ensure agenix has decrypted the secret first
          after = [ "agenix-install.service" ];
          wants = [ "agenix-install.service" ];
          
          serviceConfig = {
            # This tells systemd to read variables from this file.
            # We must use the agenix path.
            EnvironmentFile = lib.mkForce config.age.secrets.k3s-dsn.path;
          };
        };
      };
    };



    # 3. Open Firewall Ports
    networking.firewall= {
      allowedTCPPorts = [
        22
        80
        443
        2049 # nfs v4
        #2379 # etcd client - REQUIRED for HA  : Using Kine for HA
        #2380 # etcd peer - REQUIRED for HA : Using Kind for HA
        6443
        6444
        8472 # Flannel VXLAN
        10250 # Kubelet metrics      
        51820 # If you ever switch to Flannel Wireguard backend
        30007 # gitea ssh port
        30008 # free
        30009 # free
        30010 # free
        30011 # free
      ];
      allowedUDPPorts = [
        112
        8472 # Flannel VXLAN
        # 10250 # Kubelet metrics      
        51820 # If you ever switch to Flannel Wireguard backend
      ]; # VRRP protocol for Keepalived
      # Flannel needs to be able to route traffic between interfaces
      checkReversePath = false;    
    };

    age = {
      identityPaths = [ "/etc/ssh/k3s_ssh_host_ed25519_key" "/etc/nervasion/nixbuild/nixbuild_id_ed25519" ];
      secrets = {
        k3s-token = {
          file = builtins.trace "DEBUG: k3sTokenAgeFile is ${toString cfg.k3sTokenAgeFile}" cfg.k3sTokenAgeFile;  
          path = "/etc/k3s-node-token";
          owner = "root";
          group = "root";
          mode = "0600";        
        };
        ssh_host_ed25519_key.file = secrets.per.k3s_ssh_host_ed25519_key;
        ssh_host_rsa_key.file = secrets.per.k3s_ssh_host_rsa_key;

        # Define the CA Certificate
        k3s-server-ca-crt = {
          file = secrets.per.k3s-server-ca-crt;
          path = "/var/lib/rancher/k3s/server/tls/server-ca.crt";
          mode = "644";
        };

        # Define the CA Private Key
        k3s-server-ca-key = {
          file = secrets.per.k3s-server-ca-key;
          path = "/var/lib/rancher/k3s/server/tls/server-ca.key";
          mode = "600";
        };        
        
        # Define the CA Certificate
        k3s-client-ca-crt = {

          file = secrets.per.k3s-client-ca-crt;
          path = "/var/lib/rancher/k3s/client/tls/client-ca.crt";
          mode = "644";
        };

        # Define the CA Private Key
        k3s-client-ca-key = {
          file = secrets.per.k3s-client-ca-key;
          path = "/var/lib/rancher/k3s/client/tls/client-ca.key";
          mode = "600";
        };
        
        # connection string to kine db
        k3s-dsn.file = secrets.per.postgres-connection-string;

      };
    };
    environment = {
      systemPackages = with pkgs; [
        openiscsi
        nfs-utils # Longhorn also requires this for backups/RWX volumes
        emacs-nox
      ];
    };

    system.activationScripts = {
      install-agenix-key = {
        text = ''
      mkdir -p /etc/ssh
      echo "${sshKeyContent}" > /etc/ssh/k3s_ssh_host_ed25519_key
      chmod 600 /etc/ssh/k3s_ssh_host_ed25519_key
    '';
      };
      iscsiadm = {  #longhorn
        text = ''
    mkdir -p /usr/bin
    ln -sfn ${pkgs.openiscsi}/bin/iscsiadm /usr/bin/iscsiadm
  '';
      };      
    };
    users.users.${profile.user} = {
      extraGroups = [ "wheel" ];
      openssh = {
        authorizedKeys.keys = u.getOrDefault profile "authorizedKeys" [];
      };
    };
  };
}


