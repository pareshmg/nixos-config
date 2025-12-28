{ config, lib, pkgs, profile, vmid, ... }:

let
  sslCertificate = "/etc/ssl/nervasion/fullchain.pem";
  sslCertificateKey = "/etc/ssl/nervasion/privkey.pem";
in

{

  imports = [
    ../basedev
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

  environment.systemPackages = [ pkgs.docker-compose ];


  virtualisation = {
    docker = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      #dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      #defaultNetwork.settings.dns_enabled = true;
    };
  };


  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services = {
    # Set a few recommended defaults.
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      appendHttpConfig = ''
        # Add HSTS header with preloading to HTTPS requests.
        # Adding this header to HTTP requests is discouraged
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;

        # Enable CSP for your services.
        #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

        # Minimize information leaked to other domains
        #add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header 'Referrer-Policy' 'same-origin';

        # Disable embedding as a frame
        #add_header X-Frame-Options DENY;
        add_header X-Frame-Options SAMEORIGIN;

        # Prevent injection of code in other mime types (XSS Attacks)
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";

        # This might create errors
        # proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";

        # robots
        add_header X-Robots-Tag none;

        # permissions
        #add_header Permissions-Policy "geolocation=(),midi=(),sync-xhr=(),microphone=(),camera=(),magnetometer=(),gyroscope=(),fullscreen=(self)";


        proxy_headers_hash_max_size 512;
        proxy_headers_hash_bucket_size 128;
        proxy_buffering off;

      '';


      virtualHosts = {
        "zwavejs.l.nervasion.com" = {
          inherit sslCertificate sslCertificateKey;
          forceSSL = true;

          extraConfig = ''
            #ssl_dhparam /etc/ssl/nervasion/dhparams.pem;
          '';

          locations."/" = {
            proxyPass = "http://localhost:8091/";
            extraConfig = ''
              allow 10.28.0.0/16; # LAN
              allow 10.60.177.28/32; # parmbp VPN
              allow 10.60.177.29/32; # parpxl VPN
              deny all;
              proxy_set_header Host $host;
              proxy_redirect http:// https://;
              proxy_http_version 1.1;
              #proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $connection_upgrade;
            '';
          };
        };

        "homeassistant.l.nervasion.com" = {
          inherit sslCertificate sslCertificateKey;
          forceSSL = true;

          extraConfig = ''
            ssl_dhparam /etc/ssl/nervasion/dhparams.pem;
          '';

          locations."/" = {
            proxyPass = "http://localhost:8123/";
            extraConfig = ''
              allow 10.28.0.0/16; # LAN
              allow 10.60.177.28/32; # parmbp VPN
              allow 10.60.177.29/32; # parpxl VPN
              allow 10.60.177.6/32; # eiphone vpn
              allow 10.60.177.7/32; # esurface vpn
              #allow 10.11.12.3/32; # par mobile VPN
              #allow 10.11.12.8/32; # esm VPN
              deny all;
              proxy_set_header Host $host;
              proxy_redirect http:// https://;
              proxy_http_version 1.1;
              #proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $connection_upgrade;
            '';
          };
        };

      };

    };

    apcupsd = {
      enable = true;
      configText = ''
        UPSTYPE usb
        NISIP 127.0.0.1
        BATTERYLEVEL 50
        MINUTES 5
        ONBATTERYDELAY 1
      '';
      hooks = {
        onbattery = ''
          # shutdown pve
          ssh root@pve shutdown -h now
        '';
      };

    };

  };

}
