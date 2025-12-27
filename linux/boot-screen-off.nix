{ lib, pkgs, ... }:
let
  term-screen-off = pkgs.callPackage ./term-screen-off.nix { };

in
{
  # Define the systemd service unit
  systemd.services.boot-screen-off = {
    description = "Monitors shell history for user inactivity and initiates shutdown.";
    
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${lib.getExe term-screen-off}";
      TimeoutSec = 300;

    };
    requires = [ "local-fs.target" "network-online.target" ];
    after = [ "local-fs.target" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  # Define the systemd timer unit that triggers the service periodically
  systemd.timers.boot-screen-off = {
    description = "Timer to periodically check user shell history for inactivity.";
    # This links the timer to the service unit it should activate.
    # Run the service once shortly after boot.
    timerConfig = {
      Unit = "boot-screen-off.service";
      OnUnitActiveSec = "10m";
      OnBootSec = "10m";
      Persistent = false;
    };
    # Ensure this timer is enabled when systemd starts its timers target.
    wantedBy = [ "timers.target" ];
  };
}
