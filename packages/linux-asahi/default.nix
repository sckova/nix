# packages/linux-asahi/default.nix
{
  lib,
  callPackage,
  kernel-asahi,
  linuxPackagesFor,
  _kernelPatches ? [ ],
}@args:
let
  extraArgs = lib.removeAttrs args [
    "lib"
    "callPackage"
    "linuxPackagesFor"
    "kernel-asahi"
    "_kernelPatches"
  ];
  linux-asahi = callPackage linux-asahi-pkg { };
  linux-asahi-pkg =
    {
      lib,
      buildLinux,
      stdenv,
      ...
    }:
    buildLinux (
      lib.recursiveUpdate rec {
        inherit stdenv lib;
        extraMeta.branch = "fairydust";

        kernelPatches = [
          {
            features.rust = true;
            name = "Asahi config";
            patch = null;

            structuredExtraConfig =
              with lib.kernel;
              {
                # Can not be built as a module, defaults to no
                APPLE_M1_CPU_PMU = yes;
                APPLE_PMGR_MISC = yes;
                APPLE_PMGR_PWRSTATE = yes;
                # Might lead to the machine rebooting if not loaded soon enough
                APPLE_WATCHDOG = yes;
                # Needed for GPU
                ARM64_16K_PAGES = yes;
                ARM64_ACTLR_STATE = yes;
                ARM64_MEMORY_MODEL_CONTROL = yes;
                # Defaults to 'y', but we want to allow the user to set options in modprobe.d
                HID_APPLE = module;
              }
              # fairydust experimental features
              // {
                APPLE_MAILBOX = yes;
                APPLE_RTKIT = yes;
                APPLE_RTKIT_HELPER = yes;
                RUST_APPLE_RTKIT = yes;
                RUST_FW_LOADER_ABSTRACTIONS = yes;
              };
          }
        ]
        ++ _kernelPatches;

        modDirVersion = version;
        pname = "linux-asahi-fairydust";
        src = kernel-asahi;
        version = "7.1.6";
      } extraArgs
    );
in
lib.recurseIntoAttrs (linuxPackagesFor linux-asahi)
