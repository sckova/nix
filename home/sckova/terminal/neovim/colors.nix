{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.nixvim = {
    colorschemes.base16 = {
      enable = true;

      colorscheme =
        let
          cleanScheme = {
            inherit (config.scheme.withHashtag)
              base00
              base01
              base02
              base03
              base04
              base05
              base06
              base07
              base08
              base09
              base0A
              base0B
              base0C
              base0D
              base0E
              base0F
              ;
          };
        in
        cleanScheme
        // {
          base08 = config.scheme.withHashtag.${config.colors.accent};
        }
        // (
          if (builtins.elem config.colors.accent (builtins.attrNames cleanScheme)) then
            { ${config.colors.accent} = cleanScheme.base08; }
          else
            { }
        );

      setUpBar = false;
    };

    highlight = {
      CursorLineNr = {
        bg = "NONE";
        ctermbg = "NONE";
      };

      EndOfBuffer = {
        bg = "NONE";
        ctermbg = "NONE";
      };

      FoldColumn = {
        bg = "NONE"; # the color of the fold icons and backdrop
        fg = config.scheme.withHashtag.base04;
      };

      # the color of the actual folded text line
      Folded = {
        bg = "NONE";
        fg = config.scheme.withHashtag.base03;
      };

      LineNr = {
        bg = "NONE";
        ctermbg = "NONE";
      };

      # enable transparency
      Normal = {
        bg = "NONE";
        ctermbg = "NONE";
      };

      NormalFloat = {
        bg = "NONE";
        ctermbg = "NONE";
      };

      NormalNC = {
        bg = "NONE";
        ctermbg = "NONE";
      };

      SignColumn = {
        bg = "NONE";
        ctermbg = "NONE";
      };
    };
  };

}
