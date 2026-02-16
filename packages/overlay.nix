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

  vintagestory = prev.vintagestory.overrideAttrs (oldAttrs: {
    version = "1.21.4";
    src = prev.fetchurl {
      url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_1.21.4.tar.gz";
      hash = "sha256-npffJgxgUMefX9OiveNk1r4kVqsMaVCC1jcWaibz9l8=";
    };
  });

  riff = final.callPackage ./riff { };

  # linuxPackages_asahi = prev.linuxPackages_asahi.override {
  #   _kernelPatches = [
  #     {
  #       name = "Mailbox and RTKIT support";
  #       patch = null;
  #       structuredExtraConfig = with prev.lib.kernel; {
  #         APPLE_MAILBOX = yes;
  #         APPLE_RTKIT = yes;
  #         APPLE_RTKIT_HELPER = yes;
  #         RUST_APPLE_RTKIT = yes;
  #         RUST_FW_LOADER_ABSTRACTIONS = yes;
  #       };
  #     }
  #   ];
  # };
}
