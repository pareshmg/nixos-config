{ config, lib, pkgs, ... }:

{
  enable = true;
  # syntaxHighlighting.enable = true;
  enableCompletion = false;
  initExtra = ''                            # Zsh theme
    if [ -f ~/.profile_personal ]; then
        source ~/.profile_personal
    fi
    if [ -f ~/.cmt ]; then
        source ~/.cmt
    fi
    #autoload -U promptinit; promptinit
    # Hook direnv
    #emulate zsh -c "$(direnv hook zsh)"
    #eval "$(direnv hook zsh)"
  '';

  plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
    {
      name = "powerlevel10k-config";
      src = lib.cleanSource ./p10k-config;
      file = "p10k.zsh";
    }
  ];

  oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "history-substring-search"
      "tmux"
      "per-directory-history"
      "docker"
      "kubectl"
      "z"
    ];

  };
}
