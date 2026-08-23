# home/sckova/games/morrowind.nix
{ pkgs-unstable, ... }: {
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
}
