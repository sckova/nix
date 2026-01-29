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
}
