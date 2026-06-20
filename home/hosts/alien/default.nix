{
  pkgs,
  ...
}:
{
  colors = {
    scheme = "catppuccin-mocha";
    accent = "base0D";
  };

  home.packages = with pkgs; [
    ckan
    spotify
    adwsteamgtk
    gamemode
  ];

  xdg.desktopEntries.steam-big-picture = {
    name = "Steam (Big Picture)";
    icon = "steam";
    exec = "tmux new-session -d -s steam-big-picture -- gamescope -e --force-grab-cursor -s 2 -- steam -tenfoot";
    terminal = false;
    categories = [
      "Network"
      "FileTransfer"
      "Game"
    ];
  };

  home.sessionVariables = {
    PROTON_ENABLE_NVAPI = 1;
    PROTON_DLSS_UPGRADE = 1;
    PROTON_ENABLE_NGX_UPDATER = 1;
    DXVK_NVAPI_DRS_SETTINGS = "NGX_DLSS_SR_MODE=balanced";
    MANGOHUD_CONFIG = "fps_limit=144,gamemode,ram,vram";
  };
}
