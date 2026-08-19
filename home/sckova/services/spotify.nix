{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  home.packages =
    with pkgs;
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin [
      # needed to run 'spotifyd auth' (the home-manager module will add this to the path on linux)
      spotifyd
    ];

  launchd.agents = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    spotifyd = {
      config = {
        KeepAlive = true;

        ProgramArguments = [
          "${pkgs.spotifyd}/bin/spotifyd"
          "--config-path=${
            (pkgs.formats.toml { }).generate "spotifyd.conf" config.services.spotifyd.settings
          }"
          "--no-daemon"
        ];

        RunAtLoad = true;
        StandardErrorPath = "/tmp/spotifyd.err.log";
        StandardOutPath = "/tmp/spotifyd.out.log";
      };

      enable = true;
    };
  };

  programs.spotify-player = {
    enable = true;

    settings = {
      actions = [
        {
          action = "ToggleLiked";
          key_sequence = "C-l";
        }
      ];

      copy_command.command = if pkgs.stdenv.hostPlatform.isLinux then "wl-copy" else "pbcopy";

      device = {
        audio_cache = false;
        autoplay = false;
        bitrate = 320;
        device_type = "speaker";
        name = "player@${osConfig.networking.hostName}";
        normalization = false;
        volume = 100;
      };
    };
  };

  services.spotifyd = {
    enable = lib.mkIf pkgs.stdenv.hostPlatform.isLinux true;

    # comments taken from https://docs.spotifyd.rs/configuration/index.html
    settings.global = {
      #-------ä
      # OTHER #
      #-------#
      # After the music playback has ended, start playing similar songs based on the previous tracks.
      # By default, `spotifyd` infers this setting from the user settings.
      autoplay = false;
      #-------#
      # AUDIO #
      #-------#
      # The audio backend used to play music. To get
      # a list of possible backends, run `spotifyd --help`.
      backend = if pkgs.stdenv.hostPlatform.isLinux then "alsa" else "portaudio"; # use portaudio for macOS [homebrew]
      # The audio bitrate. 96, 160 or 320 kbit/s
      bitrate = 320;
      # The bus to bind to with the MPRIS interface.
      # Possible values: "session", "system"
      # The system bus can be used if no graphical session is available
      # (e.g. on headless systems) but you still want to be able to use MPRIS.
      # NOTE: You might need to add appropriate policies to allow spotifyd to
      # own the name.
      dbus_type = "session";
      # The alsa audio device to stream audio. To get a
      # list of valid devices, run `aplay -L`,
      device = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "default"; # omit for macOS
      #---------#
      # GENERAL #
      #---------#
      # The name that gets displayed under the connect tab on
      # official clients.
      device_name = "daemon@${osConfig.networking.hostName}";
      # The displayed device type in Spotify clients.
      # Can be unknown, computer, tablet, smartphone, speaker, t_v,
      # a_v_r (Audio/Video Receiver), s_t_b (Set-Top Box), and audio_dongle.
      device_type = "computer";
      #-----------#
      # DISCOVERY #
      #-----------#
      # If set to true, this disables zeroconf discovery.
      # This can be useful, if one prefers to run a single-user instance.
      disable_discovery = true;
      # Volume on startup between 0 and 100
      initial_volume = 100;
      # The maximal size of the cache directory in bytes
      # The value below corresponds to ~ 10GB
      max_cache_size = 10000000000;
      # The directory used to store credentials and audio cache.
      # Default: infers a sensible cache directory (e.g. on Linux: $XDG_CACHE_HOME)
      # Note: The file path does not get expanded. Environment variables and
      # shell placeholders like $HOME or ~ don't work!
      # cache_path = "";
      # If set to true, audio data does NOT get cached.
      # In this case, the cache is only used for credentials.
      no_audio_cache = false;
      # The normalisation pregain that is applied for each song.
      normalisation_pregain = 0;
      # If set to true, `spotifyd` tries to bind to dbus (default is the session bus)
      # and expose MPRIS controls. When running headless, without the session bus,
      # you should set this to false, to avoid errors. If you still want to use MPRIS,
      # have a look at the `dbus_type` option.
      use_mpris = pkgs.stdenv.hostPlatform.isLinux;
      # The volume controller. Each one behaves different to
      # volume increases. For possible values, run
      # `spotifyd --help`.
      volume_controller = if pkgs.stdenv.hostPlatform.isLinux then "alsa" else "softvol"; # use softvol for macOS
      # If set to true, enables volume normalisation between songs.
      volume_normalisation = true;
    };
  };

}
