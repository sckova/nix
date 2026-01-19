final: prev: {
  spotify-webapp = final.callPackage ./spotify-webapp {};

  catppuccin-discord = final.callPackage ./catppuccin-discord {
    inherit (final) catppuccin-discord-git;
  };

  openmw = final.callPackage ./openmw {
    openmw = prev.openmw;
    inherit (final) openmw-git;
  };

  linuxPackages_asahi = prev.linuxPackages_asahi.override {
    _kernelPatches = [
      {
        name = "Mailbox and RTKIT support";
        patch = null;
        structuredExtraConfig = with prev.lib.kernel; {
          APPLE_MAILBOX = yes;
          APPLE_RTKIT = yes;
          APPLE_RTKIT_HELPER = yes;
          RUST_APPLE_RTKIT = yes;
          RUST_FW_LOADER_ABSTRACTIONS = yes;
        };
      }
    ];
  };
}
