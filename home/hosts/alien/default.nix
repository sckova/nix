# home/hosts/alien/default.nix
{
  pkgs,
  ...
}:
{
  colors = {
    accent = "base0D";
    scheme = "catppuccin-mocha";
  };

  home = {
    packages = with pkgs; [
      adwsteamgtk
      ckan
      gamemode
    ];

    sessionVariables = {
      DXVK_NVAPI_DRS_SETTINGS = "NGX_DLSS_SR_MODE=balanced";
      MANGOHUD_CONFIG = "fps_limit=144,gamemode,ram,vram";
      PROTON_DLSS_UPGRADE = 1;
      PROTON_ENABLE_NGX_UPDATER = 1;
      PROTON_ENABLE_NVAPI = 1;
    };
  };

  xdg.desktopEntries.steam-big-picture = {
    categories = [
      "Network"
      "FileTransfer"
      "Game"
    ];

    exec = "tmux new-session -d -s steam-big-picture -- gamescope -e --force-grab-cursor -s 2 -- steam -tenfoot";
    icon = "steam";
    name = "Steam (Big Picture)";
    terminal = false;
  };
}
