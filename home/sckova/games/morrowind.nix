# home/sckova/games/morrowind.nix
{
  pkgs,
  hostname,
  pkgs-unstable,
  ...
}:
{
  home = {
    packages = with pkgs-unstable; [ openmw ];

    sessionVariables = {
      GL_THREADED_OPTIMIZATIONS = "1"; # this improves FPS considerably on nvidia
      SDL_VIDEO_DRIVER = "wayland";
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
                  --force-grab-cursor \
                  --cursor-scale-height 1400 \
                  -s 3 \
                  -r 144 \
                  -f \
                  -- \
                  env \
                  __NV_PRIME_RENDER_OFFLOAD=1 \
                  __GLX_VENDOR_LIBRARY_NAME=nvidia \
                  SDL_VIDEODRIVER=x11 \
                  ${pkgs.gamemode}/bin/gamemoderun ${pkgs.openmw}/bin/openmw "$@"
              ''
            else
              /* bash */ ''
                exec ${pkgs.gamemode}/bin/gamemoderun ${pkgs.openmw}/bin/openmw "$@"
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
