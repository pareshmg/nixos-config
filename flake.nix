#
#  G'Day
#  Behold is my personal Nix, NixOS and Darwin Flake.
#  I'm not the sharpest tool in the shed, so this build might not be the best out there.
#  I refer to the README and other org document on how to use these files.
#  Currently and possibly forever a Work In Progress.
#
#  flake.nix *             
#   ├─ ./hosts
#   │   └─ default.nix
#   ├─ ./darwin
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#

{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs = # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11"; # Default Stable Nix Packages
      nixpkgs-master.url = "github:nixos/nixpkgs/master"; # Default Stable Nix Packages
      nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
      nixos-hardware.url = "github:NixOS/nixos-hardware";
      #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Unstable Nix Packages
      # dslr.url = "github:nixos/nixpkgs/nixos-22.11";                        # Quick fix

      agenix = {
        url = "github:ryantm/agenix";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      home-manager = {
        # User Package Management
        url = "github:nix-community/home-manager/release-25.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      darwin = {
        url = "github:lnl7/nix-darwin/nix-darwin-25.11"; # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };

      flake-utils = {
        url = "github:numtide/flake-utils";
      };

      u = {
        #url = "git+file:.?dir=utils";
        url = "github:pareshmg/nixos-config?dir=utils";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nixos-generators = {
        url = "github:nix-community/nixos-generators";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # nur = {                                                               # NUR Packages
      #   url = "github:nix-community/NUR";                                   # Add "nur.nixosModules.nur" to the host modules
      # };

      # nixgl = {                                                             # OpenGL
      #   url = "github:guibou/nixGL";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };

      # emacs-overlay = {                                                     # Emacs Overlays
      #   url = "github:nix-community/emacs-overlay";
      #   flake = false;
      # };

      # doom-emacs = {                                                        # Nix-community Doom Emacs
      #   url = "github:nix-community/nix-doom-emacs";
      #   inputs.nixpkgs.follows = "nixpkgs";
      #   inputs.emacs-overlay.follows = "emacs-overlay";
      # };

      # hyprland = {                                                          # Official Hyprland flake
      #   url = "github:vaxerski/Hyprland";                                   # Add "hyprland.nixosModules.default" to the host modules
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };
      # plasma-manager = {                                                    # KDE Plasma user settings
      #   url = "github:pjones/plasma-manager";                               # Add "inputs.plasma-manager.homeManagerModules.plasma-manager" to the home-manager.users.${user}.imports
      #   inputs.nixpkgs.follows = "nixpkgs";
      #   inputs.home-manager.follows = "nixpkgs";
      # };

      # disko = { # disk partitioning
      #   url = "github:nix-community/disko";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };

      secrets.url = "github:pareshmg/nixos-config?dir=secrets_example"; #  NOTE: OVERRIDE THIS!!!
      snix.url = "git+ssh://git@github.com/salescience/snix";

      t2-firmware.url = "github:pareshmg/nixos-config?dir=secrets_example"; #  NOTE: OVERRIDE THIS!!!
      
    };

  outputs = { self, nixpkgs, nixpkgs-master, nixos-hardware, flake-utils, home-manager, darwin, agenix, u, secrets, nixos-generators, snix, nixpkgs-darwin, t2-firmware, ... } @ inputs: # Function that tells my flake which to use and what do what to do with the dependencies.
    let # Variables that can be used in the config files.
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      forAllLinuxSystems = nixpkgs.lib.genAttrs (builtins.filter (x: (builtins.elemAt (builtins.split "-" x) 2) == "linux") nixpkgs.lib.systems.flakeExposed);
      forAllDarwinSystems = nixpkgs.lib.genAttrs (builtins.filter (x: (builtins.elemAt (builtins.split "-" x) 2) == "darwin") nixpkgs.lib.systems.flakeExposed);
      devShell = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = with pkgs; mkShell {
            nativeBuildInputs = with pkgs; [ bashInteractive git age ];
            shellHook = with pkgs; ''
              export EDITOR=emacs
            '';
          };
        };
      sPkgs = system: import nixpkgs { inherit system; };
      darwin-build = system: import ./builders/darwin-build.nix { inherit darwin system; };
    in
    # Use above variables in ...
    {
      formatter = forAllSystems (system: (sPkgs system).nixpkgs-fmt);


      overlays = {
        ollama-master = final: prev: {
          ollama-master =
            let
              pkgs-master = import nixpkgs-master { inherit (final) system; config.allowUnfree = true; };
            in
            pkgs-master.ollama-cuda;
        };
      };


      packages = u.recursiveMerge [
        (forAllLinuxSystems (system: {
          guivm = nixos-generators.nixosGenerate {
            inherit system;
            format = "proxmox";
            specialArgs = { inherit inputs home-manager u; } // { hostname = "testvm"; profile = u.recursiveMerge [ secrets.profile.test secrets.profile.nervasion ]; vmid = "111"; };
            modules = [
              nixos-generators.nixosModules.all-formats
              home-manager.nixosModules.home-manager
              ./hosts/guivm
            ];
          };
          testvm = nixos-generators.nixosGenerate {
            inherit system;
            format = "proxmox";
            specialArgs = { inherit inputs home-manager u; } // { hostname = "testvm"; profile = u.recursiveMerge [ secrets.profile.test secrets.profile.nervasion ]; vmid = "111"; };
            modules = [
              nixos-generators.nixosModules.all-formats
              home-manager.nixosModules.home-manager
              ./hosts/minimal
              ./hosts/testvm
              ./hosts/testvm/proxmox.nix
            ];
          };
          waylandvm = nixos-generators.nixosGenerate {
            inherit system;
            format = "proxmox";
            specialArgs = { inherit inputs home-manager u; } // { hostname = "testvm"; profile = u.recursiveMerge [ secrets.profile.test secrets.profile.nervasion ]; vmid = "111"; };
            modules = [
              nixos-generators.nixosModules.all-formats
              home-manager.nixosModules.home-manager
              ./hosts/minimal
              ./hosts/waylandvm
              ./hosts/waylandvm/proxmox.nix
            ];
          };
          minimalvm = nixos-generators.nixosGenerate {
            inherit system;
            format = "proxmox";
            specialArgs = { inherit inputs home-manager u; } // { hostname = "minimal"; profile = u.recursiveMerge [ secrets.profile.test secrets.profile.nervasion ]; vmid = "111"; };
            modules = [
              nixos-generators.nixosModules.all-formats
              ./hosts/minimal
            ];
          };
          basedevvm = nixos-generators.nixosGenerate {
            inherit system;
            format = "proxmox";
            specialArgs = { inherit inputs home-manager u agenix secrets; } // { hostname = "basedev"; profile = u.recursiveMerge [ secrets.profile.test secrets.profile.nervasion ]; vmid = "112"; };
            modules = [
              nixos-generators.nixosModules.all-formats
              home-manager.nixosModules.home-manager
              ./hosts/basedev
            ];
          };
          ha = nixos-generators.nixosGenerate {
            inherit system;
            format = "proxmox";
            specialArgs = { inherit inputs home-manager u agenix secrets; } // { hostname = "ha"; profile = u.recursiveMerge [ secrets.profile.ha secrets.profile.nervasion ]; vmid = "112"; };
            modules = [
              nixos-generators.nixosModules.all-formats
              home-manager.nixosModules.home-manager
              ./hosts/ha
              ./hosts/ha/proxmox.nix
            ];
          };
          nixcache = nixos-generators.nixosGenerate {
            inherit system;
            format = "proxmox";
            specialArgs = { inherit inputs home-manager u agenix secrets; } // { hostname = "nixcache"; profile = u.recursiveMerge [ secrets.profile.nixcache secrets.profile.nervasion ]; vmid = "200"; };
            modules = [
              nixos-generators.nixosModules.all-formats
              home-manager.nixosModules.home-manager
              agenix.nixosModules.default
              ./hosts/nixcache
              ./hosts/nixcache/proxmox.nix
            ];
          };
        } //
        (let
          clusterIp = secrets.profile.k3s.clusterIp;
          serverIps = secrets.profile.k3s.serverIps;
          ipPrefixLength = secrets.profile.k3s.ipPrefixLength;
        in {

          k8s-master0 = let
            vmconf = {
              vmid = "300";
            };
            hostname = "k8s-master0";
            profile = u.recursiveMerge [ secrets.profile.k3s secrets.profile.nervasion {ip=builtins.elemAt serverIps 0;}]; 
          in 
            nixos-generators.nixosGenerate {
            inherit system;
            format = "proxmox";
            specialArgs = { inherit inputs home-manager u vmconf hostname profile; } ;
            modules = [
              nixos-generators.nixosModules.all-formats
              agenix.nixosModules.default
              home-manager.nixosModules.home-manager
              ./hosts/minimal
              ./hosts/minimal/proxmox.nix
              ./hosts/k3s/common.nix
              {
                config.services.k3s-cluster = {
                  inherit serverIps clusterIp;
                  enable = true;
                  machineMode = "first-server";
                  k3sTokenAgeFile = secrets.per.k3s-token;
                  ipPrefixLength = ipPrefixLength;
                };
                
              }
            ];
          };
          
        })))
        (forAllSystems (system:
          let
            pkgs = sPkgs system;
          in
          {
            bootstrap = pkgs.callPackage ./modules/build/nix-bootstrap.nix { };
            rebuild = pkgs.callPackage ./modules/build/nix-rebuild.nix { };
            default = pkgs.callPackage ./modules/build/nix-rebuild.nix { };
          }
        ))
      ];

      devShells = forAllSystems devShell;

      nixosConfigurations =
        {
          vm = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs agenix secrets home-manager u; } // { hostname = "nix"; profile = u.recursiveMerge [ secrets.profile.work secrets.profile.per secrets.profile.nervasion secrets.profile.vm ]; };
            modules = [
              # Modules that are used
              {
                nixpkgs.overlays = [ self.overlays.ollama-master ];
              }
              agenix.nixosModules.default
              home-manager.nixosModules.home-manager
              ./hosts/configuration.nix
              ./shared/configuration-per.nix
              ./shared/configuration-ssai.nix
              ./hosts/vm
            ];
          };
          minimal = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs agenix secrets home-manager u; } // { hostname = "minimal"; profile = u.recursiveMerge [ secrets.profile.test secrets.profile.nervasion secrets.profile.vm ]; };
            modules = [
              # Modules that are used
              #./hosts/minimal
            ];
          };
          ha = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs home-manager u; } // { hostname = "ha"; profile = u.recursiveMerge [ secrets.profile.ha secrets.profile.nervasion ]; vmid = "112"; };
            modules = [
              nixos-generators.nixosModules.all-formats
              home-manager.nixosModules.home-manager
              ./hosts/ha
            ];
          };
          testvm2 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux"; # System architecture
            specialArgs = { inherit inputs home-manager u; } // { hostname = "testvm2"; profile = secrets.profile.test; };
            modules = [
              # Modules that are used
              home-manager.nixosModules.home-manager
              ./hosts/testvm
            ];
          };


          pmp-cape = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = { inherit inputs agenix secrets home-manager u t2-firmware system; } // { hostname = "pmp-cape"; profile = u.recursiveMerge [ secrets.profile.nervasion secrets.profile.per ]; };
            modules = [
              # Modules that are used
              agenix.darwinModules.default
              home-manager.nixosModules.home-manager
              nixos-hardware.nixosModules.apple-t2
              ./hosts/t2/configuration.nix
              ./shared/configuration-per.nix
              ./shared/configuration.nix
              ./shared/configuration-per.nix
            ];
          };
          
          
          # import ./hosts {                                                    # Imports ./hosts/default.nix
          #   inherit (nixpkgs) lib;
          #   inherit inputs nixpkgs nixpkgs-unstable home-manager agenix;   # Also inherit home-manager so it does not need to be defined here.
          # }
        };

      darwinConfigurations = forAllSystems (system: {
        # Darwin Configurations

        pm4 = darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit system inputs agenix secrets home-manager u; } // { hostname = "pm4"; profile = u.recursiveMerge [ secrets.profile.work secrets.profile.per ]; };
          modules = [
            # Modules that are used
            agenix.darwinModules.default
            home-manager.darwinModules.home-manager
            snix.darwinModules.default
            ./shared/configuration.nix
            ./shared/configuration-per.nix
            ./shared/configuration-ssai.nix
            ./darwin/configuration.nix
            ./darwin/configuration-per.nix
            ./darwin/configuration-ssai.nix
          ];
        };



        # pmpcmt =
        #   let
        #     #cmtnix = builtins.getFlake "git+ssh://git@github.com/Censio/CMTNix";
        #   in
        #   darwin.lib.darwinSystem {
        #     inherit system;
        #     specialArgs = { inherit inputs agenix secrets home-manager cmtnix u; } // { hostname = "pmp-cmt"; profile = secrets.profile.work; };
        #     modules = [
        #       # Modules that are used
        #       agenix.darwinModules.default
        #       home-manager.darwinModules.home-manager
        #       cmtnix.darwinModules.cmtnix
        #       ./shared/configuration.nix
        #       ./darwin/configuration.nix
        #       ./darwin/configuration-cmt.nix
        #     ];
        #   };
      });

      homeConfigurations = forAllSystems (system: {
        # Non-NixOS configurations
        ubuntu =
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            profile = secrets.profile.ubuntu;
            cmtcfg = u.getOrDefault profile "cmt" null;
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs system pkgs agenix secrets home-manager profile; };
            modules = [
              agenix.homeManagerModules.default
              ./linux/minimal-home.nix
            ];
          };

        ${secrets.profile.per.user} =
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            profile = secrets.profile.per;
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs system pkgs agenix secrets home-manager profile; };
            modules = [
              agenix.homeManagerModules.default
              ./linux/minimal-home.nix
              ./linux/home.nix
            ];
          };
      });





    };
}
