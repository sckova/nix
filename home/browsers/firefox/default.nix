# https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        userChrome = ./userChrome.css;
        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            plasma-integration
            stylus
            violentmonkey
            consent-o-matic
            privacy-badger
            sponsorblock
          ];
          settings = {
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
              dbInChromeStorage = true; # required for Stylus
            };
          };
        };
        settings = {
          "extensions.autoDisableScopes" = 0; # enables all extensions automatically
          "xpinstall.signatures.required" = false;
          "extensions.update.autoUpdateDefault" = false;
          "extensions.update.enabled" = false;
          "browser.search.defaultenginename" = "google";
          "browser.search.order.1" = "google";

          "signon.rememberSignons" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.cache.disk.enable" = true; # Set to false if you have a HDD
          "browser.warnOnQuitShortcut" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # "mousewheel.default.delta_multiplier_x" = 100;
          # "mousewheel.default.delta_multiplier_y" = 100;
          # "mousewheel.default.delta_multiplier_z" = 100;

          # Firefox 75+ remembers the last workspace it was opened on as part of its session management.
          # This is annoying, because I can have a blank workspace, click Firefox from the launcher, and
          # then have Firefox open on some other workspace.
          "widget.disable-workspace-management" = true;
        };
        search = {
          force = true;
          default = "google";
          order = [
            "google"
          ];
        };
      };
    };
  };
}
