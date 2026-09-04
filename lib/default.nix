# lib/default.nix
{
  imports = [
    ./home-manager.nix
    ./nix-settings.nix
    ./sops.nix
    ./users.nix
  ];
}
