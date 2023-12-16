#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./desktop OR ./laptop OR ./work OR ./vm
#            ├─ ./default.nix
#            └─ ./home.nix
#

{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, location, agenix, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  # fix = import dslr {
  #   inherit system;
  #   config.allowUnfree = true;                              # Allow proprietary software
  # };

  lib = nixpkgs.lib;
in
{
  # desktop = lib.nixosSystem {                               # Desktop profile
  #   inherit system;
  #   specialArgs = {
  #     inherit inputs unstable system user location fix hyprland;
  #     host = {
  #       hostName = "desktop";
  #       mainMonitor = "HDMI-A-2";
  #       secondMonitor = "DP-3";
  #     };
  #   };                                                      # Pass flake variable
  #   modules = [                                             # Modules that are used.
  #     nur.nixosModules.nur
  #     hyprland.nixosModules.default
  #     ./desktop
  #     ./configuration.nix

  #     home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
  #       home-manager.useGlobalPkgs = true;
  #       home-manager.useUserPackages = true;
  #       home-manager.extraSpecialArgs = {
  #         inherit unstable user fix doom-emacs;
  #         host = {
  #           hostName = "desktop";     #For Xorg iGPU  | Videocard     | Hyprland iGPU
  #           mainMonitor = "HDMI-A-2"; #HDMIA3         | HDMI-A-1      | HDMI-A-3
  #           secondMonitor = "DP-3";   #DP1            | DisplayPort-1 | DP-1
  #         };
  #       };                                                  # Pass flake variable
  #       home-manager.users.${user} = {
  #         imports = [
  #           ./home.nix
  #           ./desktop/home.nix
  #         ];
  #       };
  #     }
  #   ];
  # };

  # laptop = lib.nixosSystem {                                # Laptop profile
  #   inherit system;
  #   specialArgs = {
  #     inherit unstable inputs user location;
  #     host = {
  #       hostName = "laptop";
  #       mainMonitor = "eDP-1";
  #       secondMonitor = "Virtual-2";
  #     };
  #   };
  #   modules = [
  #     hyprland.nixosModules.default
  #     ./laptop
  #     ./configuration.nix

  #     home-manager.nixosModules.home-manager {
  #       home-manager.useGlobalPkgs = true;
  #       home-manager.useUserPackages = true;
  #       home-manager.extraSpecialArgs = {
  #         inherit unstable user;
  #         host = {
  #           hostName = "laptop";
  #           mainMonitor = "eDP-1";
  #         };
  #       };
  #       home-manager.users.${user} = {
  #         imports = [(import ./home.nix)] ++ [(import ./laptop/home.nix)];
  #       };
  #     }
  #   ];
  # };

  # work = lib.nixosSystem {                                  # Work profile
  #   inherit system;
  #   specialArgs = {
  #     inherit unstable inputs user location hyprland;
  #     host = {
  #       hostName = "work";
  #       mainMonitor = "eDP-1";
  #       secondMonitor = "HDMI-A-2";
  #       thirdMonitor = "DP-1";
  #     };
  #   };
  #   modules = [
  #     hyprland.nixosModules.default
  #     ./work
  #     ./configuration.nix

  #     home-manager.nixosModules.home-manager {
  #       home-manager.useGlobalPkgs = true;
  #       home-manager.useUserPackages = true;
  #       home-manager.extraSpecialArgs = {
  #         inherit unstable user;
  #         host = {
  #           hostName = "work";
  #           mainMonitor = "eDP-1";
  #           secondMonitor = "HDMI-A-2";
  #           thirdMonitor = "DP-1";
  #         };
  #       };
  #       home-manager.users.${user} = {
  #         imports = [(import ./home.nix)] ++ [(import ./work/home.nix)];
  #       };
  #     }
  #   ];
  # };

  # web = (let
  #   user = "docker";
  # in
  #   lib.nixosSystem {
  #     inherit system;
  #     specialArgs = {
  #       inherit inputs user location;
  #       host = {
  #         hostName = "web";
  #       };
  #     };
  #     modules = [
  #       ./web
  #     ];
  #   });

  # vm = (let
  #   user="pareshmg";
  # in
  #   lib.nixosSystem {                                    # VM profile
  #     system = "x86_64-linux";                                  # System architecture
  #     #inherit system;
  #     specialArgs = {
  #       inherit  user inputs location agenix;
  #       host = {
  #         hostName = "vm";
  #         #mainMonitor = "Virtual-1";
  #         #secondMonitor = "Virtual-2";
  #       };
  #     };
  #     modules = [
  #       agenix.nixosModules.default
  #       home-manager.nixosModules.home-manager {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.extraSpecialArgs = {
  #           inherit  user;
  #           host = {
  #             hostName = "vm";
  #             #mainMonitor = "Virtual-1";
  #             #secondMonitor = "Virtual-2";
  #           };
  #         };
  #         home-manager.users.${user} = {
  #           imports = [(import ./home.nix)] ++ [(import ./vm/home.nix)];
  #         };
  #       }
  #       ./vm
  #       ./configuration.nix
  #     ];
  #   });

  guivm = (let
    user="pareshmg";
  in
    lib.nixosSystem {                                    # VM profile
      inherit system;
      specialArgs = {
        inherit unstable inputs user location;
        host = {
          hostName = "guivm";
          mainMonitor = "Virtual-1";
          secondMonitor = "Virtual-2";
        };
      };
      modules = [
        ./guivm
        ./configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit unstable user;
            host = {
              hostName = "guivm";
              mainMonitor = "Virtual-1";
              secondMonitor = "Virtual-2";
            };

          };
          home-manager.users.${user} = {
            imports = [(import ./home.nix)] ++ [(import ./guivm/home.nix)];
          };
        }
      ];
    });

}
