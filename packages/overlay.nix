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

  prismlauncher-unwrapped-master = prev.callPackage (builtins.path {
    path = ./prismlauncher-unwrapped-master/package.nix;
  }) { };

  prismlauncher-master = prev.callPackage (builtins.path {
    path = ./prismlauncher-master/package.nix;
  }) { };

  strawberry-master = prev.callPackage (builtins.path {
    path = ./strawberry/package.nix;
  }) { };

  widevine-firefox = prev.callPackage (builtins.path { path = ./widevine-firefox/package.nix; }) { };
}
