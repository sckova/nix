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
      ./colors.nix
      ./keybinds.nix
      ./pedantix.nix
      ./plugins/coding.nix
      ./plugins/lualine.nix
      ./settings.nix
      nixvim.homeModules.nixvim
      pedantix.homeModules.default
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
