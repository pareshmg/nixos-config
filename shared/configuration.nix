{ inputs, config, lib, pkgs, agenix, ... }:

{
  nixpkgs.config.allowUnfree = true;

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      #carlito                                 # NixOS
      #vegur                                   # NixOS
      #source-code-pro
      fira-code
      meslo-lgs-nf
      julia-mono
      font-awesome
      #corefonts
      (nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
    ];
  };

  # enable zsh by default
  programs = {                            # Shell needs to be enabled
    zsh = {
      enable = true;
      enableCompletion = false;
    };
  };

  environment = {
    shells = with pkgs; [ zsh ];          # Default shell
    variables = {
      EDITOR = "emacs";
      VISUAL = "emacs";
    };
    systemPackages = (import ./system-packages.nix {inherit pkgs;}) ++ (with pkgs; [
      # agenix
      agenix.packages."${stdenv.hostPlatform.system}".default
    ]);
  };

  nix = {                                   # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      options = "--delete-older-than 2d";
    };
    package = pkgs.nix;    # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

}
