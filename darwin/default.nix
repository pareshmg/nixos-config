#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix *
#       ├─ configuration.nix
#       └─ home.nix
#

{ lib, inputs, nixpkgs, home-manager, darwin, user, agenix, ...}:

{
  pmp = darwin.lib.darwinSystem {                       # MacBook8,1 "Core M" 1.2 12" (2015) A1534 ECM2746 profile
    system = "x86_64-darwin";
    hostname = "pmp";
    specialArgs = { inherit user inputs hostname; };
    modules = [                                             # Modules that are used
      home-manager.darwinModules.home-manager
      ./configuration.nix
    ];
  };

  pmp-cmt = darwin.lib.darwinSystem {                       # MacBook8,1 "Core M" 1.2 12" (2015) A1534 ECM2746 profile
    system = "aarch64-darwin";
    hostname = "pmp-cmt";
    specialArgs = { inherit user inputs hostname; };
    modules = [                                             # Modules that are used
      home-manager.darwinModules.home-manager
      ./configuration.nix
    ];
  };
}
