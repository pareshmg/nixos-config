{ config, lib, pkgs, profile, secrets, vmid, ... }:

let
  sslCertificate = "/etc/ssl/nervasion/fullchain.pem";
  sslCertificateKey = "/etc/ssl/nervasion/privkey.pem";
in

{

  imports = [
    ../minimal
    ../../shared/sshd.nix
  ];

  # systemd.network.enable = true;

  # services.cloud-init = {
  #   enable = true;
  #   network.enable = true;
  #   config = ''
  #     system_info:
  #       distro: nixos
  #       network:
  #         renderers: [ 'networkd' ]
  #       default_user:
  #         name: ${profile.user}
  #     users:
  #         - default
  #     ssh_pwauth: false
  #     chpasswd:
  #       expire: false
  #     cloud_init_modules:
  #       - migrator
  #       - seed_random
  #       - growpart
  #       - resizefs
  #     cloud_config_modules:
  #       - disk_setup
  #       - mounts
  #       - set-passwords
  #       - ssh
  #     cloud_final_modules: []
  #     '';
  # };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "${secrets.per.nix-serve-priv-key}";
  };

  # generate with `nix-store --generate-binary-cache-key nixcache.l.nervasion.com cache-priv-key.pem cache-pub-key.pem`
  environment.etc = {
    "nix-cache/nix-cache-priv-key.pem" = {
      source = secrets.per.nix-serve-priv-key;
    };
  };

  nix = {
    extraOptions = ''
      secret-key-files = /etc/nix-cache/nix-cache-priv-key.pem
    '';

    sshServe = {
      enable = true;
      write = true;
      keys = [
        # nervasion
        "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBACdCcnDMlZdwzU3A780Gr5+/UFIBKeRglduF0nYrIOG17rH2ulRs0LP542ZKokXe7wdQxTiHJtDqPd20O8i5OztSgHzI1qzgzvzJBL+KCIjVNXA6VYFngGYNTgSWOJaq3gg/+u4+P7exDG3v6/WRWYp4cq+8iBbNvWEVTQLR7TMxNJaCw== pareshmg@neravsion"
        # nix builder
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQuWLutTYqV0P83FL3Cuhho4BLQ9tvqbH3e8U6/yQux pareshmg@nervasion.com"
      ];
    };

    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };

  };

  users.users.${profile.user}.extraGroups = [ "wheel" ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # age = {
  #   secrets = {
  #     cache-priv-key-pem = {
  #       file = secrets.per.cache-priv-key-pem;
  #       path = "/var/cache-priv-key.pem";
  #       owner = "${profile.user}";
  #       mode = "666";
  #       symlink = false;
  #     };
  #   };
  #   identityPaths = profile.identityPaths;
  # };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      # ... existing hosts config etc. ...
      "nixcache.l.example.com" = {
        locations."/" = {
          proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
          extraConfig = ''
            allow 10.28.0.0/16; # LAN
            allow 10.60.177.28/32; # parmbp VPN
            #allow 10.60.177.29/32; # parpxl VPN
            deny all;
            proxy_set_header Host $host;
            #proxy_redirect http:// https://;
            proxy_http_version 1.1;
            #proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #proxy_set_header Upgrade $http_upgrade;
            #proxy_set_header Connection $connection_upgrade;
          '';
        };
      };
    };
  };


}
