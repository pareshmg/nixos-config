{ inputs, config, lib, pkgs, agenix, ... }:
{
  imports = [
    ./dev.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/New_York";
  # security.rtkit.enable = true;
  # security.polkit.enable = true;

  
  # nixpkgs.config.allowUnfree = true;
  ids.gids.nixbld = 350;

  fonts = {
    # Fonts
    # fontDir.enable = true;
    packages = with pkgs; [
      #fonts = with pkgs; [
      #carlito                                 # NixOS
      #vegur                                   # NixOS
      #source-code-pro
      fira-code
      meslo-lgs-nf
      julia-mono
      font-awesome
      #corefonts
      nerd-fonts.fira-code
    ];
  };

  # enable zsh by default
  programs = {
    # Shell needs to be enabled
    zsh = {
      enable = true;
      enableCompletion = false;
    };
  };

  environment = {
    shells = with pkgs; [ zsh ]; # Default shell
    variables = { };
    systemPackages = (import ./system-packages.nix { inherit pkgs; }) ++ (with pkgs; [
      # agenix
      agenix.packages."${stdenv.hostPlatform.system}".default
    ]);
  };

  nix = {
    # Nix Package Manager settings
    optimise = {
      #automatic = true;
    };
    settings = {
      keep-going = true;
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      options = "--delete-older-than 15d";
    };
    package = pkgs.nix; # Enable nixFlakes on system
    # package = pkgs.nixVersions.nix_2_26;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

}
