final: prev: {
  widevine-helium =
    if prev.stdenv.hostPlatform.system == "aarch64-linux" then
      prev.callPackage ./helium-browser/widevine-aarch64-linux.nix { }
    else
      null;

  # helium-browser =
  #   prev.callPackage
  #     (builtins.path {
  #       path = ./helium-browser/package.nix;
  #     })
  #     {
  #       helium-widevine = prev.callPackage (builtins.path {
  #         path = ./helium-browser/widevine-aarch64-linux.nix;
  #       }) { };
  #     };

  helium-browser =
    let
      helium-widevine = prev.callPackage ./helium-browser/widevine-aarch64-linux.nix { };
    in
    prev.callPackage ./helium-browser/package.nix {
      inherit helium-widevine;
    };

  noctalia-shell-custom = prev.callPackage (builtins.path {
    path = ./noctalia-shell-custom/package.nix;
  }) { };

  spotifyd = prev.callPackage (builtins.path { path = ./spotifyd/package.nix; }) { };

  widevine-firefox = prev.callPackage (builtins.path { path = ./widevine-firefox/package.nix; }) { };
}
