{ config, lib, pkgs, profile, secrets, u, location, ... }:
let
  bcachekey = "";
in
{
  imports = [
    ../minimal
    ../../shared/configuration.nix
    ../../shared/sshd.nix
  ];

  users.users.${profile.user} = {
    extraGroups = [ "wheel" ];
  };


  nix = {
    settings = {
      substituters = [
        #"ssh://nix-ssh@nixcache.l.nervasion.com"
        "http://nixcache.l.nervasion.com"
      ];
      trusted-public-keys = [
        secrets.common.nix-serve-pub-key
      ];
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit profile u location; };
    users.${profile.user}.imports = [
      ../../shared/home.nix
    ];
  };
}
