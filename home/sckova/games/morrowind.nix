{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [ openmw-unstable ];
    sessionVariables.SDL_VIDEO_DRIVER = "wayland";
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
