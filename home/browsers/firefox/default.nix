# https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
{ pkgs, ... }:

{
  home.sessionVariables = rec {
    MOZ_GMP_PATH = "${pkgs.widevine-firefox}/gmp-widevinecdm/system-installed";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [
        pkgs.firefoxpwa
      ];
    };
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
            pwas-for-firefox
            control-panel-for-twitter
          ];
          settings = {
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
              force = true;
              settings = {
                dbInChromeStorage = true;
              };
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
          "browser.toolbars.bookmarks.visibility" = "newtab";

          "signon.rememberSignons" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.cache.disk.enable" = true; # Set to false if you have a HDD
          "browser.warnOnQuitShortcut" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "widget.disable-workspace-management" = true;
          "browser.contentblocking.category" = {
            Value = "strict";
            Status = "locked";
          };
          "widget.gtk.global-menu.enabled" = true;
          "widget.gtk.global-menu.wayland.enabled" = true;
          "browser.tabs.inTitlebar" = 0;
          "extensions.pocket.enabled" = false;
          "extensions.screenshots.disabled" = true;
          "browser.topsites.contile.enabled" = false;
          "browser.formfill.enable" = false;
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showWeather" = false;

          "media.gmp-widevinecdm.version" = "system-installed";
          "media.gmp-widevinecdm.visible" = true;
          "media.gmp-widevinecdm.enabled" = true;
          "media.gmp-widevinecdm.autoupdate" = false;

          "media.eme.enabled" = true;
          "media.eme.encrypted-media-encryption-scheme.enabled" = true;

          # Vertical tabs
          "sidebar.verticalTabs" = true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
          "browser.uiCustomization.navBarWhenVerticalTabs" = [
            "back-button"
            "forward-button"
            "stop-reload-button"
            "urlbar-container"
            "downloads-button"
            "fxa-toolbar-menu-button"
            "unified-extensions-button"
          ];
        };
        bookmarks = {
          force = true;
          settings = [
            {
              name = "Nix sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "NixOS";
                  url = "https://nixos.org/";
                }
              ];
            }
            {
              name = "ovips.us.to";
              toolbar = true;
              bookmarks = [
                {
                  name = "ovips.us.to";
                  url = "https://ovips.us.to/";
                }
              ];
            }
          ];
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
