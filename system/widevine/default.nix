# https://github.com/nix-community/nixos-apple-silicon/issues/145
# This should work with both x86_64 and aarch64. (hopefully)
{
  config,
  lib,
  ...
}:
{
  nixpkgs.overlays = lib.mkIf (config.nixpkgs.hostPlatform.isLinux) [
    (
      final: prev:
      let
        # Determine the correct directory name based on the system architecture
        archDir =
          if final.stdenv.hostPlatform.isAarch64 then
            "linux_arm64"
          else if final.stdenv.hostPlatform.isx86_64 then
            "linux_x64"
          else
            throw "Unsupported architecture for Widevine CDM";
      in
      {
        wrapFirefox =
          browser: opts:
          let
            extraPrefs = (opts.extraPrefs or "") + ''
              lockPref("media.gmp-widevinecdm.version", "system-installed");
              lockPref("media.gmp-widevinecdm.visible", true);
              lockPref("media.gmp-widevinecdm.enabled", true);
              lockPref("media.gmp-widevinecdm.autoupdate", false);
              lockPref("media.eme.enabled", true);
              lockPref("media.eme.encrypted-media-encryption-scheme.enabled", true);
            '';
            widevineCdmDir = "${final.widevine-cdm}/share/google/chrome/WidevineCdm";
            widevineOutDir = "$out/gmp-widevinecdm/system-installed";
          in
          (prev.wrapFirefox browser (opts // { inherit extraPrefs; })).overrideAttrs (previousAttrs: {
            buildCommand = previousAttrs.buildCommand + ''
              mkdir -p "${widevineOutDir}"
              ln -s "${widevineCdmDir}/_platform_specific/${archDir}/libwidevinecdm.so" "${widevineOutDir}/libwidevinecdm.so"
              ln -s "${widevineCdmDir}/manifest.json" "${widevineOutDir}/manifest.json"
              wrapProgram "$oldExe" --set MOZ_GMP_PATH "${widevineOutDir}"
            '';
          });
      }
    )
  ];
}
