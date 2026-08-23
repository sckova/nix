# packages/mkxp-z/default.nix
{
  lib,
  SDL2,
  SDL2_image,
  SDL2_sound,
  SDL2_ttf,
  alsa-lib,
  fetchFromGitHub,
  flac,
  fluidsynth,
  freetype,
  git,
  glib,
  harfbuzz,
  jack2,
  lame,
  lerc,
  libGL,
  libdeflate,
  liberation_ttf,
  libjpeg,
  libmpg123,
  libopus,
  libsndfile,
  libsysprof-capture,
  libtheora,
  libtiff,
  libuchardet,
  libvorbis,
  libwebp,
  makeWrapper,
  meson,
  ninja,
  openal,
  pcre2,
  physfs,
  pixman,
  pkg-config,
  pulseaudio,
  ruby,
  soundfont-fluid,
  stdenv,
  xxd,
  xz,
  zlib,
  zstd,
}:

stdenv.mkDerivation rec {
  NIX_LDFLAGS = "-ltheoradec";

  buildInputs = [
    ruby
    SDL2
    SDL2_image
    SDL2_sound
    SDL2_ttf
    physfs
    openal
    libvorbis
    libtheora
    zlib
    pixman
    git
    libGL
    harfbuzz
    freetype
    glib
    libsysprof-capture
    pcre2
    libuchardet
    libtiff
    libdeflate
    libjpeg
    lerc
    xz
    zstd
    libwebp
    fluidsynth
    libsndfile
    flac
    libopus
    libmpg123
    pulseaudio
    alsa-lib
    jack2
    lame
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    install -m 755 "$(find . -maxdepth 1 -type f -name "mkxp-z.*")" $out/bin/mkxp-z

    wrapProgram $out/bin/mkxp-z \
      --set SDL_SOUNDFONTS "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2" \
      --prefix XDG_DATA_DIRS : "${liberation_ttf}/share"

    runHook postInstall
  '';

  mesonFlags = [
    "-Dworkdir_current=true"
    "-Dmri_version=${ruby.version.major}.${ruby.version.minor}"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    xxd
    makeWrapper
  ];

  pname = "mkxp-z";

  postPatch = ''
    # dehardcode lib lookups
    sed -i "s/find_library(['\"]iconv['\"])/find_library('m')/g" src/meson.build
    sed -i "s/find_library(['\"]charset['\"])/find_library('m')/g" src/meson.build

    # fix SDL2_ttf 2.24+ API breakage
    find src -type f -exec sed -i 's/_TTF_Font/TTF_Font/g' {} +

    # fix SDL2_sound includes
    find src -type f -exec sed -i 's/<SDL_sound.h>/<SDL2\/SDL_sound.h>/g' {} +

    # inject Ruby arch dir into $LOAD_PATH before zlib require
    substituteInPlace binding/binding-mri.cpp \
      --replace \
        'rb_eval_string_protect("require('"'"'zlib'"'"') if !Kernel.const_defined?(:Zlib)", &state);' \
        'rb_eval_string("$LOAD_PATH.unshift(\"${ruby}/lib/ruby/${ruby.version.libDir}/\" + RbConfig::CONFIG[\"arch\"])"); rb_eval_string("class File; class << self; alias_method :exists?, :exist?; end; end"); rb_eval_string_protect("require('"'"'zlib'"'"') if !Kernel.const_defined?(:Zlib)", &state);'

    substituteInPlace src/display/bitmap.cpp \
      --replace \
        'int alignY = rect.y + ((rect.h - alignmentHeight) / 2) - scaledOutlineSize;' \
        'int alignY = rect.y + ((rect.h - TTF_FontHeight(sdlFont)) / 2) - scaledOutlineSize;'

    # Ruby 3.2+ removed File.exists? -- add compatibility shim
    echo 'class File; class << self; alias_method :exists?, :exist?; end; end' \
      >> scripts/preload/mkxp_wrap.rb

    patchShebangs linux/
  '';

  src = fetchFromGitHub {
    hash = "sha256-iu7mHmEwxNvysqOM6ugTeTEek9u1fGxBiuoXlnPkUj8=";
    owner = "mkxp-z";
    repo = "mkxp-z";
    rev = version;
  };

  version = "66939a31a8977615228d1b229ba71553deb72c8d";

  meta = with lib; {
    description = "Open-source implementation of RGSS (RPG Maker)";
    homepage = "https://github.com/mkxp-z/mkxp-z";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
