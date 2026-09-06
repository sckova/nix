# lib/nix-settings.nix
{
  inputs,
  isLinux,
  users,
  ...
}:
{
  nix = {
    gc = {
      options = "--delete-older-than 30d";
      automatic = true;
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = [ "root" ] ++ users;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = import ../packages/overlay.nix {
      inherit inputs isLinux;
    };
  };
}
