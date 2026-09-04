# lib/default.nix
{
  imports = [
    ./nix-settings.nix
    ./sops.nix
    ./users.nix
    ./home-manager.nix
  ];
}
