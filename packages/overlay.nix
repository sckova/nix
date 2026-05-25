inputs: final: prev: {
  inherit (prev.lixPackageSets.stable)
    nixpkgs-review
    nix-eval-jobs
    nix-fast-build
    colmena
    ;

  spotify-webapp = final.callPackage ./spotify-webapp { };
  bibata-cursor = final.callPackage ./bibata-cursor { };
  openmw-unstable = prev.openmw.overrideAttrs (oldAttrs: {
    pname = "openmw";
    src = inputs.openmw;
    version = "${inputs.openmw.rev}";
  });

  linux-asahi = prev.linux-asahi.override {

    _kernelPatches = [
      {
        name = "Asahi RTKit and Mailbox config additions";
        patch = null;
        structuredExtraConfig = with final.lib.kernel; {
          APPLE_MAILBOX = yes;
          APPLE_RTKIT = yes;
          APPLE_RTKIT_HELPER = yes;
          RUST_APPLE_RTKIT = yes;
          RUST_FW_LOADER_ABSTRACTIONS = yes;
        };
      }
    ];

    callPackage =
      fn: args:
      prev.callPackage fn (
        args
        // {
          fetchFromGitHub =
            _:
            prev.fetchFromGitHub {
              owner = "AsahiLinux";
              repo = "linux";
              rev = "f9f31e394acadb47e564a867a3538f6a87db956e";
              hash = "sha256-vT9uGCgi0uKssJ78bctBh8NNR2GnOIPICKtdU1+GQYE=";
            };
        }
      );
  };

  linuxPackages_asahi = final.linux-asahi;
}
