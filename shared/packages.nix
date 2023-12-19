{ pkgs }:

with pkgs; [
  # General packages for development and system management

  # doom emacs
  clang

  # act
  # alacritty
  aspell
  # aspellDicts.en
  # bash-completion
  # bat
  # btop
  # coreutils
  # difftastic
  # du-dust
  # git-filter-repo
  # killall
  # neofetch
  # openssh
  # pandoc
  # sqlite
  wget
  zip

  # Encryption and security tools
  # _1password
  #age
  # age-plugin-yubikey
  gnupg
  # libfido2
  # pinentry
  # yubikey-manager

  # Cloud-related tools and SDKs
  # docker
  # docker-compose
  # awscli2
  # cloudflared
  # flyctl
  # google-cloud-sdk
  # go
  # gopls
  # ngrok
  # ssm-session-manager-plugin
  # terraform
  # terraform-ls
  # tflint

  # Media-related packages
  # emacs-all-the-icons-fonts
  # dejavu_fonts
  # ffmpeg
  # font-awesome
  # glow
  # hack-font
  # noto-fonts
  # noto-fonts-emoji
  # meslo-lgs-nf

  # Node.js development tools
  # fzf
  # nodePackages.live-server
  # nodePackages.nodemon
  # nodePackages.prettier
  # nodePackages.npm
  # nodejs

  # Source code management, Git, GitHub tools
  # gh
  git-lfs
  pre-commit
  commitlint

  # Text and terminal utilities
  htop
  hunspell
  # iftop
  # jetbrains-mono
  jq
  gettext
  # tree
  tmux
  unrar
  unzip
  zsh-powerlevel10k
  zstd

  # k8s
  kubetail

  # Python packages
  (let
    my-python-packages = ps: with ps; [
      pandas
      requests
      ipython
      # other python packages
    ];
  in
    python311.withPackages my-python-packages)
  python311Packages.virtualenv
  python311Packages.pip
  python311Packages.setuptools
]
