{
  pkgs,
  inputs,
  ...
}:
let
  asahi-artwork = pkgs.fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "artwork";
    rev = "80d14f8b6f485b310e305a84b4b806361518ddd1";
    hash = "sha256-1r7gPFsn3GmKO4YsixsK7eyQWfVjsWnuOEtSCQequn8=";
  };
in
{
  imports = with inputs; [
    steam-asahi.nixosModules.default
  ];

  programs.steam-asahi.enable = true;

  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/login-screen".logo =
        "${asahi-artwork}/logos/svg/AsahiLinux_logo_horizontal_darkbg.svg";
    }
  ];

  # environment.systemPackages = with pkgs; [
  #   # note for wine support (should be done by 26.05 release):
  #   # https://github.com/NixOS/nixpkgs/issues/412458
  #   muvm
  #   fex
  # ];

  services.logind.settings.Login = {
    HandleSuspendKey = "ignore";
    HandlePowerKey = "lock";
    HandleLidSwitch = "lock";
  };
}
