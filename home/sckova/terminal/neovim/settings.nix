{
  pkgs,
  ...
}:
{
  programs.nixvim = {
    autoCmd = [
      {
        command = "lua require('otter').activate({'bash'}, true, true, nil)";
        event = [ "FileType" ];
        pattern = [ "nix" ];
      }
    ];

    clipboard = {
      providers = {
        pbcopy.enable = pkgs.stdenv.hostPlatform.isDarwin;
        wl-copy.enable = pkgs.stdenv.hostPlatform.isLinux;
      };

      register = "unnamedplus";
    };

    defaultEditor = true;
    enablePrintInit = true;
    globals.mapleader = "\\";
    nixpkgs.useGlobalPackages = true;

    opts = {
      autocomplete = true;
      expandtab = true;

      fillchars = {
        eob = " ";
        fold = " ";
        foldclose = "";
        foldinner = " ";
        foldopen = "";
        foldsep = " ";
      };

      foldcolumn = "1";
      foldenable = true;
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldlevel = 99;
      foldlevelstart = 99;
      foldmethod = "expr";
      number = true;
      numberwidth = 4;
      shiftwidth = 2;
      softtabstop = 2;
      statuscolumn = "%C %s%=%l ";
      tabstop = 2;
    };

    waylandSupport = pkgs.stdenv.hostPlatform.isLinux;
  };
}
