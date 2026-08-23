# home/sckova/terminal/neovim/default.nix
{
  lib,
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

  home.sessionVariables.EDITOR = lib.mkForce "nvim";

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}
