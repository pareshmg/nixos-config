{ config, pkgs, ... }:
let
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng# for preview and export as html
      metafont parskip xcolor biblatex enumitem supertabular fontawesome5 titlesec multirow geometry## resume
      wrapfig amsmath ulem hyperref capt-of
      footnotehyper booktabs adjustbox eso-pic txfonts microtype setspace
      pgf # tikz
      helvetic   # This adds the phv (Helvetica) font files
      psnfss    # Recommended for standard PostScript fonts
      ;
    #(setq org-latex-compiler "lualatex")
    #(setq org-preview-latex-default-process 'dvisvgm)
  };
in
{
  # home-manager
  home.packages = with pkgs; [
    tex
  ];
}
