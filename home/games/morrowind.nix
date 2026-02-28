{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ openmw-unstable ];
  home.sessionVariables.SDL_VIDEO_DRIVER = "wayland";

  programs.firefox.profiles.default.search.engines.uesp = {
    name = "Unofficial Elder Scrolls Pages";
    urls = [
      {
        template = "https://en.uesp.net/w/index.php?title=Special%3ASearch&search={searchTerms}&button=";
      }
    ];
    definedAliases = [ "uesp" ];
  };
}
