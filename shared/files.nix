{ pkgs, config, profile, u, ... }:
let
in
{
  # tmux
  ".tmux.conf" = {
    # can do this either via source or text
    source = ./config/tmux.conf;
  };
  ".profile_personal" = {
    source = ./config/profile_personal;
  };
  ".aliases" = {
    text = u.substProfile profile ./config/aliases;
  };
  ".gitconfig" = {
    text = u.substProfile profile ./config/gitconfig;
  };
  ".config/doom/personal/me.el" = {
    text = u.substProfile profile ./config/me.el;
  };

  # emacs recursive copy in dir
  ".config/doom" = {
    source = ./config/emacs/doom;
    recursive = true;
    onChange =
      let
        scmd = if builtins.hasAttr "system" config then "source ${config.system.build.setEnvironment}" else "";
      in
      ''
            ${scmd}
            if [ -f ${config.home.profileDirectory}/etc/profile.d/nix.sh ]; then
                source ${config.home.profileDirectory}/etc/profile.d/nix.sh
            elif [ -f /etc/profile.d/nix.sh ]; then
                source /etc/profile.d/nix.sh
            fi
            if [ -e /run/current-system/sw/bin ]; then
                PATH=$PATH:/run/current-system/sw/bin
            fi

            ${scmd}
            EMACS="$HOME/.config/emacs"
            DOOMDIR="$HOME/.config/doom"

            if [ ! -d "$EMACS" ]; then
                ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs.git $EMACS
                yes | $EMACS/bin/doom install
        	  fi
            $EMACS/bin/doom sync
      '';
  };
}
