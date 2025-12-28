{ config, lib, pkgs, profile, ... }:

{
  systemd.services."vm-build" = {
    script = ''
      cd ~/
      ${pkgs.coreutils}/bin/echo "Hello World"
    '';
    serviceConfig = {
      OnCalendar = "daily";
      Persistent = true;
      User = "${profile.user}";
    };
  };
}
