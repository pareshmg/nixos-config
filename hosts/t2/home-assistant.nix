{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      homeassistant = {
        volumes = [
          "/home/pareshmg/dev/ha/haconfig:/config"
          "/home/pareshmg/dev/ha/ha:/homeassistant"
        ];
        environment.TZ = "America/New_York";
        # Note: The image will not be updated on rebuilds, unless the version label changes
        image = "ghcr.io/home-assistant/home-assistant:stable";
        extraOptions = [ 
          # Use the host network namespace for all sockets
          "--network=host"
          # Pass devices into the container, so Home Assistant can discover and make use of them
          "--device=/dev/ttyACM0:/dev/ttyACM0"
        ];
        privileged = true;
        dependsOn = [
          "pgdb"
        ];
      };

      zwavejsserver = {
        volumes = [ "/home/pareshmg/dev/ha/zwavejsserver/storage:/usr/src/app/store" ];
        #/home/pareshmg/dev/ha/pgdb:/config" ];
        environment = {
          POSTGRES_HOST_AUTH_METHOD = "trust";
          TZ = "America/New_York";
        };

        # Note: The image will not be updated on rebuilds, unless the version label changes
        image = "docker.io/zwavejs/zwavejs2mqtt:latest";
        dependsOn = [ "pgdb" ];
        privileged = true;
        devices = [
          "/dev/ttyACM0:/dev/zwave"
        ];
        extraOptions = [ 
          # Use the host network namespace for all sockets
          "--network=host"
        ];
        
      };
      
      pgdb = {
        volumes = [ "/home/pareshmg/dev/ha/pgdb:/config" ];
        environment = {
          POSTGRES_HOST_AUTH_METHOD = "trust";
          TZ = "America/New_York";
        };

        # Note: The image will not be updated on rebuilds, unless the version label changes
        image = "docker.io/library/postgres:17";
        ports = [
            "127.0.0.1:5432:5432"
        ];
      };      
      
    };
  };
}
