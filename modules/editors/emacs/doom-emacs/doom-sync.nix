{ pkgs }:

pkgs.writeShellApplication {
  name = "doom-sync";
  runtimeInputs = [ pkgs.emacs-nox pkgs.git ];
  text = ''
    EMACS="$HOME/.config/emacs"
    #DOOMDIR="$HOME/.config/doom"

    if [ ! -d "$EMACS" ]; then
      ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs.git "$EMACS"
      yes | "$EMACS"/bin/doom install
    fi
    "$EMACS"/bin/doom sync
  '';
}
