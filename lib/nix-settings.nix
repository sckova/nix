# lib/nix-settings.nix
{
  pkgs,
  inputs,
  isLinux,
  users,
  ...
}:
{
  # _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
  #   inherit (pkgs.stdenv.hostPlatform) system;
  #   config.allowUnfree = true;
  # };

  nix = {
    package = pkgs.lixPackageSets.stable.lix;

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
