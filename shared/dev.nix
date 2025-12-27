{ config, lib, pkgs, ... }:
let
  emacs = pkgs.emacs-nox;
  e-q = pkgs.writeShellApplication {
    name = "e-q";
    runtimeInputs = [ emacs ];
    text = ''
      #!/bin/sh
      exec ${emacs}/bin/emacs -Q "$@"
    '';
  };
  nix-test = pkgs.writeShellApplication {
    name = "nix-test";
    runtimeInputs = [ ];
    text = ''
      #!/bin/zsh
      if [[ "$(which less)" == "/usr/bin/less" ]]; then
          echo "Your PATH does not have nix in the beginning! Please make sure that you modify all your export PATH entries in your zshrc to look like"
          echo "    export PATH=\$PATH:/usr/bin"
          echo "and NOT like"
          echo "    export PATH=/usr/bin:\$PATH"
          exit 2
      fi

      echo "All checks passed!"
    '';
  };
in
{
  imports = [
    ../modules/shell
    ../modules/editors
  ];

  environment = {
    variables = {
      EDITOR = "${e-q}/bin/e-q";
      VISUAL = "${e-q}/bin/e-q";
    };
    systemPackages = [ e-q emacs nix-test pkgs.less ];
    shellAliases = {
      eq = "emacs -nw -Q";
    };
  };

}
