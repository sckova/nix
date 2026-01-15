{
  lib,
  clangStdenv,
  fetchFromGitHub,
  fetchgit,
  requireFile,
  cmake,
  ninja,
  pkg-config,
  boost179,
  openssl,
  avahi,
  zlib,
  libuuid,
  python3,
  git,
  libimobiledevice,
  libplist,
  libimobiledevice-glue,
  libusbmuxd,
  minizip,
  websocketpp,
  unzip,
}: let
  cpprestsdk = fetchFromGitHub {
    owner = "microsoft";
    repo = "cpprestsdk";
    rev = "v2.10.18";
    sha256 = "sha256-RCt6BIFxRDTGiIjo5jhIxBeCOQsttWViQcib7M0wZ5Y=";
    fetchSubmodules = true;
  };
in
  clangStdenv.mkDerivation {
    pname = "altserver";
    version = "unstable";

    src = fetchgit {
      url = "https://github.com/sckova/AltServer-Linux";
      rev = "f9173b0805b64517a856fc133955753fde361c63";
      hash = "sha256-ts2YnGTdI5/Ze+7900Wvyxm2YJyQQ0qBlyLMRCAN20c=";
      fetchSubmodules = true;
      deepClone = true;
    };

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
      git
      unzip
    ];

    buildInputs = [
      boost179
      openssl
      avahi
      zlib
      libuuid
      python3
      libimobiledevice
      libplist
      libimobiledevice-glue
      libusbmuxd
      minizip
      websocketpp
    ];

    NIX_CFLAGS_COMPILE = toString [
      "-D_GNU_SOURCE"
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-pointer-types"
      "-Wno-error=int-conversion"
    ];

    cmakeFlags = [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      "-DCMAKE_C_FLAGS=-Wno-error=incompatible-pointer-types -Wno-implicit-function-declaration"
      "-DCMAKE_CXX_FLAGS=-Wno-error=incompatible-pointer-types -Wno-implicit-function-declaration"
      "-Wno-dev"

      "-D_XOPEN_SOURCE=700"

      "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
      "-DFETCHCONTENT_SOURCE_DIR_CPPRESTSDK=${cpprestsdk}"
    ];

    postPatch = ''
      # The build system tries to link a non-existent static library 'corecrypto_static'.
      # We remove this dependency so it relies on the OpenSSL shims/libraries instead.
      substituteInPlace cmake/CoreCrypto/CMakeLists.txt \
        --replace-fail "corecrypto_static" ""
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      # Copy the resulting binary (name may vary slightly by fork, finding executable)
      find . -maxdepth 2 -type f -executable -name "AltServer" -exec cp {} $out/bin/ \;

      runHook postInstall
    '';

    meta = with lib; {
      description = "AltServer for Linux (fork)";
      homepage = "https://github.com/sckova/AltServer-Linux";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [];
    };
  }
