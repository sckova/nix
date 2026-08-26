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
    sessionVariables.SDL_VIDEODRIVER = "wayland";
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

  xdg.desktopEntries.openmw-performance =
    let
      isAlien = hostname == "alien";

      openmw-launcher =
        pkgs.writeShellScriptBin "openmw-launcher" # bash
          (
            if isAlien then
              /* bash */ ''
                exec ${pkgs.gamescope}/bin/gamescope \
                  --force-grab-cursor --cursor-scale-height 1400 -s 3 \
                  -w 2560 -h 1400 -F fsr --sharpness 5 \
                  -W 3840 -H 2160 -r 144 \
                  -- \
                  env \
                  SDL_VIDEODRIVER=x11 \
                  __GL_MaxFramesAllowed=1 \
                  __GL_SHADER_DISK_CACHE=1 \
                  __GL_THREADED_OPTIMIZATIONS=1 \
                  ${pkgs.gamemode}/bin/gamemoderun ${pkgs.openmw-unstable}/bin/openmw "$@"
              ''
            # vulkan backend not currently supported in asahi
            else
              /* bash */ ''
                exec ${pkgs.gamescope}/bin/gamescope \
                  --backend sdl \
                  --force-grab-cursor --cursor-scale-height 1000 -s 0.25 \
                  -w 1701 -h 1080 -F fsr --sharpness 5 \
                  -W 3024 -H 1890 -r 120 \
                  -- \
                  env \
                  SDL_VIDEODRIVER=x11 \
                  ${pkgs.gamemode}/bin/gamemoderun ${pkgs.openmw-unstable}/bin/openmw "$@"
              ''
          );
    in
    {
      categories = [
        "Game"
        "RolePlaying"
      ];

      comment = "An engine replacement for The Elder Scrolls III: Morrowind (Performance Wrapper)";
      exec = "${openmw-launcher}/bin/openmw-launcher";
      genericName = "Role Playing Game";
      icon = "openmw";
      name = "OpenMW (performance)";
      settings.Keywords = "Morrowind;Reimplementation Mods;esm;bsa;";
      terminal = false;
    };
}
