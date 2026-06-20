{ pkgs, users, ... }:
{
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        "https://attic.xuyh0120.win/lantian"
        "https://cache.garnix.io"
        "https://nixos-apple-silicon.cachix.org"
        "https://noctalia.cachix.org"
      ];

      trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];

      trusted-users = [ "root" ] ++ users;
    };

    gc = {
      automatic = true;
      # dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

}
