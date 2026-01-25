final: prev: {
  spotify-webapp = final.callPackage ./spotify-webapp { };

  catppuccin-discord = final.callPackage ./catppuccin-discord {
    inherit (final) catppuccin-discord-git;
  };

  openmw = prev.openmw.overrideAttrs (oldAttrs: {
    pname = "openmw";
    src = final.openmw-git;
    version = "${final.openmw-git.rev}";
  });

  riff = final.callPackage ./riff { };

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
