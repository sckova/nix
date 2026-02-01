{
  config,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [ openmw ];
    sessionVariables = {
      SDL_VIDEO_DRIVER = "wayland";
    };
  };

  programs.librewolf.profiles.default.search.engines.uesp = {
    name = "Unofficial Elder Scrolls Pages";
    urls = [
      {
        template = "https://en.uesp.net/w/index.php?title=Special%3ASearch&search={searchTerms}&button=";
      }
    ];
    definedAliases = [ "uesp" ];
  };
}
