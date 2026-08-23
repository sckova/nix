# home/sckova/apps/firefox/policies.nix
{
  BlockAboutConfig = false;
  DefaultDownloadDirectory = "\${home}/Downloads";
  DisableAccounts = true;
  DisableFirefoxAccounts = true;
  DisableFirefoxScreenshots = true;
  DisableFirefoxStudies = true;
  DisablePocket = true;
  DisableTelemetry = true;
  DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
  DisplayMenuBar = "always"; # alternatives: "always", "never" or "default-on"
  DontCheckDefaultBrowser = true;

  EnableTrackingProtection = {
    Cryptomining = true;
    Fingerprinting = true;
    Locked = true;
    Value = true;
  };

  OverrideFirstRunPage = "";
  OverridePostUpdatePage = "";
  SearchBar = "unified"; # alternative: "separate"
}
