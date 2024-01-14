#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ inputs, config, lib, pkgs, profile, location, hostname, ... }:

let
  user=profile.user;
  color_ssh_py = pkgs.writeScriptBin "ssh_color_py" (builtins.readFile ../shared/scripts/ssh_color.py);
in
{
  imports = [
    # ./modules/yabai.nix
    # ./modules/skhd.nix
    ../shared/dev.nix
    ../modules/cachix
  ];



  users.users."${user}" = {               # macOS user
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;                     # Default shell
  };

  networking = {
    computerName = "${hostname}";             # Host name
    hostName = "${hostname}";
  };

  environment = {
    variables = {                         # System variables
    };
    systemPackages = with pkgs; [         # Installed Nix packages
      # Terminal
      #ansible
      #ranger
      color_ssh_py
    ];
  };


  services = {
    nix-daemon.enable = true;             # Auto upgrade daemon
  };

  homebrew = {                            # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = false;                 # Auto update packages
      upgrade = false;
      cleanup = "zap";                    # Uninstall not listed packages and casks
    };
    brews = pkgs.callPackage ./brews.nix {};
    casks = pkgs.callPackage ./casks.nix {};
    masApps = { # search via mas search
      #"1password" = 1333542190;
      # "enpass" = 732710998; #  Enpass - Password Manager
      "wireguard" = 1451685025;
      "Xcode" = 497799835;

    };
  };

  nix = {
    #package = pkgs.nix;
    settings.trusted-users = [ "@admin" "${user}" ];
    gc.interval.Day = 2;
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit profile;};
    users.${user}.imports = [
      ../shared/home.nix
      ./home.nix
    ] ;
    # :{
    #   home.enableNixpkgsReleaseCheck = false;
    #   home.packages = pkgs.callPackage ./packages.nix {};
    #   home.file = lib.mkMerge [
    #     sharedFiles
    #     #additionalFiles
    #     #{ "emacs-launcher.command".source = myEmacsLauncher; }
    #   ];
    #   # home.activation.gpgImportKeys =
    #   #   let
    #   #     gpgKeys = [
    #   #       "/Users/${user}/.ssh/pgp_github.key"
    #   #       "/Users/${user}/.ssh/pgp_github.pub"
    #   #     ];
    #   #     gpgScript = pkgs.writeScript "gpg-import-keys" ''
    #   #       #! ${pkgs.runtimeShell} -el
    #   #       ${lib.optionalString (gpgKeys != []) ''
    #   #         ${pkgs.gnupg}/bin/gpg --import ${lib.concatStringsSep " " gpgKeys}
    #   #       ''}
    #   #     '';
    #   #     plistPath = "$HOME/Library/LaunchAgents/importkeys.plist";
    #   #   in
    #   #     # Prior to the write boundary: no side effects. After writeBoundary, side effects.
    #   #     # We're creating a new plist file, so we need to run this after the writeBoundary
    #   #     lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #   #       mkdir -p "$HOME/Library/LaunchAgents"
    #   #       cat >${plistPath} <<EOF
    #   #       <?xml version="1.0" encoding="UTF-8"?>
    #   #       <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    #   #       <plist version="1.0">
    #   #       <dict>
    #   #         <key>Label</key>
    #   #         <string>gpg-import-keys</string>
    #   #         <key>ProgramArguments</key>
    #   #         <array>
    #   #           <string>${gpgScript}</string>
    #   #         </array>
    #   #         <key>RunAtLoad</key>
    #   #         <true/>
    #   #       </dict>
    #   #       </plist>
    #   #       EOF

    #   #       /bin/launchctl unload ${plistPath} || true
    #   #       /bin/launchctl load ${plistPath}
    #   #     '';

    #   home.stateVersion = "23.05";
    #   programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

    #   # Marked broken Oct 20, 2022 check later to remove this
    #   # https://github.com/nix-community/home-manager/issues/3344
    #   # manual.manpages.enable = false;
    # };
  };

  # Fully declarative dock using the latest from Nix Store
  # local.dock.enable = true;
  # local.dock.entries = [
    #{ path = "/Applications/Slack.app/"; }
    #{ path = "/System/Applications/Messages.app/"; }
    #{ path = "/System/Applications/Facetime.app/"; }
    #{ path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
    #{ path = "/System/Applications/Music.app/"; }
    #{ path = "/System/Applications/News.app/"; }
    #{ path = "/System/Applications/TV.app/"; }
    #{ path = "/Applications/Asana.app/"; }
    #{ path = "/Applications/Drafts.app/"; }
    #{ path = "/System/Applications/Home.app/"; }
    # {
    #   path = toString myEmacsLauncher;
    #   section = "others";
    # }
    # {
    #   path = "${config.users.users.${user}.home}/.local/share/";
    #   section = "others";
    #   options = "--sort name --view grid --display folder";
    # }
    # {
    #   path = "${config.users.users.${user}.home}/.local/share/downloads";
    #   section = "others";
    #   options = "--sort name --view grid --display stack";
    # }
  # ];

  system = {
    checks.verifyNixPath = false; # Turn off NIX_PATH warnings now that we're using flakes
    defaults = {
      NSGlobalDomain = {                  # Global macOS system settings
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {                            # Dock settings
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
      };
      finder = {                          # Finder settings
        QuitMenuItem = false;             # I believe this probably will need to be true if using spacebar
      };  
      trackpad = {                        # Trackpad settings
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh || true''; # Since it's not possible to declare default shell, run this command after build
    stateVersion = 4;

    # defaults = {
    #   LaunchServices = {
    #     LSQuarantine = false;
    #   };

    #   NSGlobalDomain = {
    #     AppleShowAllExtensions = true;
    #     ApplePressAndHoldEnabled = false;

    #     # 120, 90, 60, 30, 12, 6, 2
    #     KeyRepeat = 2;

    #     # 120, 94, 68, 35, 25, 15
    #     InitialKeyRepeat = 15;

    #     "com.apple.mouse.tapBehavior" = 1;
    #     "com.apple.sound.beep.volume" = 0.0;
    #     "com.apple.sound.beep.feedback" = 0;
    #   };

    #   dock = {
    #     autohide = false;
    #     show-recents = false;
    #     launchanim = true;
    #     orientation = "bottom";
    #     tilesize = 48;
    #   };

    #   finder = {
    #     _FXShowPosixPathInTitle = false;
    #   };

    #   trackpad = {
    #     Clicking = true;
    #     TrackpadThreeFingerDrag = true;
    #   };
    # };

    # keyboard = {
    #   enableKeyMapping = true;
    #   remapCapsLockToControl = true;
    # };

  };
}
