# home/sckova/terminal/neovim/default.nix
{
  lib,
  pkgs,
  inputs,
  isLinux,
  ...
}:
{
  imports =
    with inputs;
    [
      nixvim.homeModules.nixvim
      pedantix.homeModules.default
      ./colors.nix
      ./keybinds.nix
      ./pedantix.nix
      ./plugins/lualine.nix
      ./plugins/coding.nix
      ./settings.nix
    ]
    ++ lib.optionals isLinux [
      ./app.nix
    ];

  home = with pkgs; {
    packages = [ page ];

    sessionVariables = {
      EDITOR = lib.mkForce "nvim";
      PAGER = lib.getExe page;
    };
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}
