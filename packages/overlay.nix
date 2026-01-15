final: prev: {
  spotify-webapp = final.callPackage ./spotify-webapp {};
  altserver-linux = final.callPackage ./altserver {};

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
