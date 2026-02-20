{
  lib,
  config,
  pkgs,
  ...
}:
{
  users.users.sckova.extraGroups = [ "qbittorrent" ];
  services = {
    qbittorrent = {
      enable = true;
      serverConfig = {
        Preferences = {
          Advanced.useSystemIconTheme = true;
          General = {
            CloseToTray = false;
            CloseToTrayNotified = true;
            ExitConfirm = false;
            Locale = "en";
          };
          WebUI = {
            Address = "*";
            Enabled = true;
            Port = 9697;
            UseUPnP = false;
          };
          BitTorrent = {
            SessionGlobalDLSpeedLimit = 0;
            GlobalUPSpeedLimit = 0;
            Port = 42578;
            QueueingSystemEnabled = false;
            SSL.Port = 63114;
            StartPaused = false;
          };
        };
      };
    };
    flaresolverr = {
      enable = true;
      port = 8191;
    };
    prowlarr = {
      enable = true;
      settings = {
        server = {
          urlbase = "localhost";
          port = 9696;
          bindaddress = "*";
        };
      };
    };
  };
}
