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

  inputs =                                                                  # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";                     # Default Stable Nix Packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Unstable Nix Packages
      # dslr.url = "github:nixos/nixpkgs/nixos-22.11";                        # Quick fix

      agenix = {
        url = "github:ryantm/agenix";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      home-manager = {                                                      # User Package Management
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      darwin = {
        url = "github:lnl7/nix-darwin/master";                              # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };

      flake-utils = {
        url = "github:numtide/flake-utils";
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

      secrets.url = "git+file:///OVERRIDE_ME_PLEASE"; #  override with
      cmtnix.url = "git+file:///OVERRIDE_ME_PLEASE"; # hiding because publishing this publically. Otherwise just put in the github repo


    };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, darwin,
              agenix, secrets, cmtnix, ... } @ inputs:   # Function that tells my flake which to use and what do what to do with the dependencies.
    let                                                                     # Variables that can be used in the config files.
      location = "$HOME/nixos-config";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      #darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      darwinSystems = [ "x86_64-darwin" ];
      forAllLinuxSystems = f: nixpkgs.lib.genAttrs linuxSystems (system: f system);
      forAllDarwinSystems = f: nixpkgs.lib.genAttrs darwinSystems (system: f system);
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) (system: f system);
      devShell = system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git age ]; #age-plugin-yubikey ];
          shellHook = with pkgs; ''
            export EDITOR=emacs
          '';
        };
      };

    in                                                                      # Use above variables in ...
    {
      # devShells = forAllSystems devShell;
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";                                  # System architecture
          specialArgs =  { inherit inputs agenix secrets home-manager location; } // {hostname = "nix"; profile=secrets.profile.per;};
          modules = [                                             # Modules that are used
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            ./shared/configuration.nix
            ./hosts/configuration.nix
            ./shared/configuration-per.nix
            ./hosts/vm
          ];
        };
        testvm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";                                  # System architecture
          specialArgs =  { inherit inputs home-manager; } // {hostname = "testvm"; profile=secrets.profile.test; vmid="111";};
          modules = [                                             # Modules that are used
            home-manager.nixosModules.home-manager
            ./hosts/guivm
          ];
        };
        # import ./hosts {                                                    # Imports ./hosts/default.nix
        #   inherit (nixpkgs) lib;
        #   inherit inputs nixpkgs nixpkgs-unstable home-manager location agenix;   # Also inherit home-manager so it does not need to be defined here.
        # }
      };

      darwinConfigurations = {                                              # Darwin Configurations
        pmp = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs =  { inherit inputs agenix secrets home-manager cmtnix location; } // {hostname = "pmp"; profile=secrets.profile.per;};
          modules = [                                             # Modules that are used
            agenix.darwinModules.default
            home-manager.darwinModules.home-manager
            cmtnix.darwinModules.cmt
            ./shared/configuration.nix
            ./shared/configuration-per.nix
            ./darwin/configuration.nix
            ./darwin/configuration-cmt.nix
            ./darwin/configuration-per.nix
          ];
        };
        pmpcmt = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs =  { inherit inputs agenix secrets home-manager cmtnix location; } // {hostname = "pmp-cmt"; profile=secrets.profile.work;};
          modules = [                                             # Modules that are used
            agenix.darwinModules.default
            home-manager.darwinModules.home-manager
            cmtnix.darwinModules.cmt
            ./shared/configuration.nix
            ./darwin/configuration.nix
            ./darwin/configuration-cmt.nix
          ];
        };
      };

      homeConfigurations = {                                                # Non-NixOS configurations
        ubuntu = let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          profile = secrets.profile.ubuntu;
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs system pkgs agenix secrets home-manager profile location; };
            modules = [
              agenix.homeManagerModules.default
              ./linux/minimal-home.nix
            ];
          };

        ${secrets.profile.per.user} = let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          profile = secrets.profile.per;
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs system pkgs agenix secrets home-manager profile location; };
            modules = [
              agenix.homeManagerModules.default
              ./linux/minimal-home.nix
              ./linux/home.nix
            ];
          };
      };
    };
}
