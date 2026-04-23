{ inputs, config, lib, pkgs, agenix, ... }:
{
  imports = [
    ./dev.nix
  ];

  # Set your time zone.
  time.timeZone = "America/New_York";
  # security.rtkit.enable = true;
  # security.polkit.enable = true;

  
  # nixpkgs.config.allowUnfree = true;
  ids.gids.nixbld = if pkgs.stdenv.isDarwin then 350 else 30000;

  fonts = {
    # Fonts
    # fontDir.enable = true;
    packages = with pkgs; [
      #fonts = with pkgs; [
      #carlito
      #vegur  
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

nixpkgs.overlays = [
  (final: prev: {
    # 1. Define your custom emacs package using the 'prev' emacs-nox
    my-emacs = (final.emacsPackagesFor prev.emacs-nox).emacsWithPackages (epkgs: [
      epkgs.vterm
      # Add other epkgs here as needed
    ]);

    # 2. If you want 'emacs-nox' to point to your custom version globally:
    # Use 'my-emacs' directly. Do NOT reference 'final.emacs-nox' here.
    emacs-nox = final.my-emacs;
  })
];
  
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
