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
    exec = "gamescope -e --force-grab-cursor -s 2 -- steam -tenfoot";
    terminal = false;
    categories = [
      "Network"
      "FileTransfer"
      "Game"
    ];
  };

  programs.niri.settings.outputs."DP-1" = {
    mode = {
      width = 3840;
      height = 2160;
      refresh = 143.999;
    };
    scale = 1.5;
    position = {
      x = 0;
      y = 0;
    };
  };

  home.sessionVariables = {
    PROTON_ENABLE_NVAPI = 1;
    PROTON_DLSS_UPGRADE = 1;
    PROTON_ENABLE_NGX_UPDATER = 1;
    DXVK_NVAPI_DRS_SETTINGS = "NGX_DLSS_SR_MODE=balanced";
    MANGOHUD_CONFIG = "fps_limit=144,gamemode,ram,vram";
  };

  programs.noctalia-shell.settings.brightness.enableDdcSupport = true;
}
