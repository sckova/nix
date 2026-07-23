{
  pkgs,
  inputs,
  ...
}:
let
  asahi-artwork = pkgs.fetchFromGitHub {
    hash = "sha256-1r7gPFsn3GmKO4YsixsK7eyQWfVjsWnuOEtSCQequn8=";
    owner = "AsahiLinux";
    repo = "artwork";
    rev = "80d14f8b6f485b310e305a84b4b806361518ddd1";
  };
in
{
  imports = with inputs; [
    steam-asahi.nixosModules.default
  ];

  programs = {
    dconf.profiles.gdm.databases = [
      {
        settings."org/gnome/login-screen".logo =
          "${asahi-artwork}/logos/svg/AsahiLinux_logo_horizontal_darkbg.svg";
      }
    ];

    steam-asahi.enable = true;
  };

  # environment.systemPackages = with pkgs; [
  #   # note for wine support (should be done by 26.05 release):
  #   # https://github.com/NixOS/nixpkgs/issues/412458
  #   muvm
  #   fex
  # ];
  services.logind.settings.Login = {
    HandleLidSwitch = "lock";
    HandlePowerKey = "lock";
    HandleSuspendKey = "ignore";
  };

  # Optional: Add your user to the "docker" group to run docker without sudo
  users.users.sckova.extraGroups = [ "docker" ];
  # In /etc/nixos/configuration.nix
  virtualisation.docker.enable = true;
}
