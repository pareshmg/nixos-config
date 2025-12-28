{ config, lib, pkgs, profile, u, ... }:

{
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
  users.users.${profile.user}.openssh.authorizedKeys.keys = u.getOrDefault profile "authorizedKeys" [ ];

}
