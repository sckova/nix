# home/sckova/games/morrowind.nix
{
  lib,
  pkgs,
  hostname,
  ...
}:
{
  home = {
    packages = [ pkgs.openmw-unstable ];

    sessionVariables = {
      SDL_VIDEO_DRIVER = "wayland";
    }
    # these improve FPS considerably on nvidia
    // lib.optionalAttrs (hostname == "alien") {
      __GL_MaxFramesAllowed = "1";
      __GL_SHADER_DISK_CACHE = "1";
      __GL_THREADED_OPTIMIZATIONS = "1";
    };
  };

  programs.firefox.profiles.default.search.engines.uesp = {
    definedAliases = [ "uesp" ];
    name = "Unofficial Elder Scrolls Pages";

    urls = [
      {
        template = "https://en.uesp.net/w/index.php?title=Special%3ASearch&search={searchTerms}&button=";
      }
    ];
  };

  xdg.desktopEntries.openmw-gamescope =
    let
      isAlien = hostname == "alien";

      openmw-launcher =
        pkgs.writeShellScriptBin "openmw-launcher" # bash
          (
            if isAlien then
              /* bash */ ''
                exec ${pkgs.gamescope}/bin/gamescope \
                  --force-grab-cursor --cursor-scale-height 1400 -s 3 \
                  -w 2560 -h 1440 -F fsr --sharpness 5 \
                  -W 3840 -H 2160 -r 144 \
                  -f \
                  -- \
                  env \
                  SDL_VIDEODRIVER=x11 \
                  ${pkgs.gamemode}/bin/gamemoderun ${pkgs.openmw-unstable}/bin/openmw "$@"
              ''
            else
              /* bash */ ''
                exec ${pkgs.gamemode}/bin/gamemoderun ${pkgs.openmw-unstable}/bin/openmw "$@"
              ''
          );
    in
    {
      categories = [
        "Game"
        "RolePlaying"
      ];

      comment = "OpenMW Wrapper Launcher";
      exec = "${openmw-launcher}/bin/openmw-launcher";
      genericName = "Role-Playing Game";
      icon = "openmw";
      name = "OpenMW (performance)";
      settings.Keywords = "openmw;morrowind;";
      terminal = false;
    };
}
