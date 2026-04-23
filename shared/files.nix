{ pkgs, config, profile, u, location, ... }:
let
  # local link a file
  llink = name: value: (if builtins.hasAttr "source" value then value // {
    source = config.lib.file.mkOutOfStoreSymlink (builtins.toString (location + "/shared" + value.source));
    recursive = false;
  } else value);

  # store link
  slink = name: value: (if builtins.hasAttr "source" value then value // { source = ./. + value.source; } else value);

  # if we want editable configs, use slink else use
  econfig = u.getOrDefault profile "editableConfig" false;
  linker = builtins.trace ("editable config is " + (pkgs.lib.trivial.boolToString econfig)) (if (u.getOrDefault profile "editableConfig" false) then llink else slink);
  doom-sync = pkgs.callPackage ../modules/editors/emacs/doom-emacs/doom-sync.nix { };
in

builtins.mapAttrs linker ({
  # tmux
  ".tmux.conf" = {
    # can do this either via source or text
    source = "/config/tmux/tmux.conf";
  };
  ".tmux/scripts/global_pane_history.sh" = {
    # can do this either via source or text
    source = "/config/tmux/global_pane_history.sh";
  };
  ".tmux/scripts/global_last_pane.sh" = {
    # can do this either via source or text
    source = "/config/tmux/global_last_pane.sh";
  };
  ".profile_personal" = {
    source = "/config/profile_personal";
  };
  ".aliases" = {
    text = u.substProfile profile ./config/aliases;
  };
  ".gitconfig" = {
    text = u.substProfile profile ./config/gitconfig;
  };
  ".config/emacs-me/me.el" = {
    text = u.substProfile profile ./config/me.el;
  };

  # ".config/aider.conf.yml" = {
  #   text = u.substProfile profile ./config/aider.config.yml;
  # };
  
  # emacs recursive copy in dir
  ".config/doom" = {
    source = "/config/emacs/doom";
    recursive = true;
    onChange = ''
      yes | ${doom-sync}/bin/doom-sync || true
    '';
  };
} // (if pkgs.stdenv.isDarwin then {
  ".config/iterm2/com.googlecode.iterm2.plist" = {
    source = "/config/iterm2/com.googlecode.iterm2.plist";
    onChange = ''
            # Specify the preferences directory
            /usr/bin/defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.config/iterm2"

            # Tell iTerm2 to use the custom preferences in the directory
            /usr/bin/defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
          '';
  };
} else {}))




# {
#   # tmux
#   ".tmux.conf" = {
#     # can do this either via source or text
#     source = ./config/tmux.conf;
#   };
#   ".profile_personal" = {
#     source = ./config/profile_personal;
#   };
#   ".aliases" = {
#     text = u.substProfile profile ./config/aliases;
#   };
#   ".gitconfig" = {
#     text = u.substProfile profile ./config/gitconfig;
#   };
#   ".config/doom/personal/me.el" = {
#     text = u.substProfile profile ./config/me.el;
#   };

#   # emacs recursive copy in dir
#   ".config/doom" = {
#     source = ./config/emacs/doom;
#     recursive = true;
#     onChange =
#       let
#         scmd = if builtins.hasAttr "system" config then "source ${config.system.build.setEnvironment}" else "";
#       in
#       ''
#             ${scmd}
#             if [ -f ${config.home.profileDirectory}/etc/profile.d/nix.sh ]; then
#                 source ${config.home.profileDirectory}/etc/profile.d/nix.sh
#             elif [ -f /etc/profile.d/nix.sh ]; then
#                 source /etc/profile.d/nix.sh
#             fi
#             if [ -e /run/current-system/sw/bin ]; then
#                 PATH=$PATH:/run/current-system/sw/bin
#             fi

#             ${scmd}
#             EMACS="$HOME/.config/emacs"
#             DOOMDIR="$HOME/.config/doom"

#             if [ ! -d "$EMACS" ]; then
#                 ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs.git $EMACS
#                 yes | $EMACS/bin/doom install
#         	  fi
#             $EMACS/bin/doom sync
#       '';
#   };
# }
