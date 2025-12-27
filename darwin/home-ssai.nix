#
#  Home-manager configuration for cmt
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   ├─ ./home.nix
#   │   └─ ./home-cmt.nix *
#

{ pkgs, lib, secrets, u, ... }:

{
  programs.vscode.enable = true;
  home = {
    
    packages = let

      kpod = pkgs.writeShellApplication {
        name = "kpod";
        runtimeInputs = with pkgs; [ kubectl ];
        text = ''
        
        kubectl get pods -n "dev-$USER" -l app="worker-$USER-app" -o  jsonpath='{.items[?(@.status.phase=="Running")].metadata.name}' | head -n 1
        '';
        
      };
      
      kpod-pull = pkgs.writeShellApplication {
        name = "kpod-pull";
        runtimeInputs = with pkgs; [ kpod kubectl git ];
        text = ''
          CUR_DIR="$(git rev-parse --show-toplevel)"
          PDIR=$(dirname "$PWD")
          RPATH=$(realpath -s --relative-to="$CUR_DIR" "$PWD")
          kubectl cp -n "dev-$USER" "$(kpod)":"/root/ssai/$RPATH" "$PDIR" -c worker
        '';

      };
      kpod-push = pkgs.writeShellApplication {
        name = "kpod-push";
        runtimeInputs = with pkgs; [ git kubectl kpod ];
        text = ''
          CUR_DIR="$HOME"
          PDIR=$(dirname "$PWD")
          RPATH=$(realpath -s --relative-to="$CUR_DIR" "$PDIR")
          echo "kubectl cp -n dev-$USER $PWD $(kpod):/root/$RPATH -c worker"
          kubectl cp -n "dev-$USER" "$PWD" "$(kpod)":"/root/$RPATH" -c worker 
        '';

      }; 

      kpod-cp = pkgs.writeShellApplication {
        name = "kpod-cp";
        runtimeInputs = with pkgs; [ kpod kubectl ];
        text = ''
          FNAME=$(readlink -f "$1")
          kubectl cp -n "dev-$USER" "$FNAME" "$(kpod)":"$2" -c worker 
        '';

      }; 
        
    in 
      [ kpod-push kpod-pull kpod kpod-cp];
        
    # Specific packages for macbook
    file = lib.mkMerge [
      { ".ssai".source = u.getOrDefault secrets "ssai.aliases" ""; }
    ];
  };

}
