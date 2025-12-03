# https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
{
  pkgs,
  config,
  lib,
  ...
}:

{
  home.sessionVariables = lib.mkIf pkgs.stdenv.hostPlatform.isAarch64 {
    MOZ_GMP_PATH = "${pkgs.widevine-firefox}/gmp-widevinecdm/system-installed";
  };

  home.file.".mozilla/firefox/default/chrome" = {
    source = ./chrome;
    force = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = with pkgs; [
        firefoxpwa
      ];
    };
    policies = {
      BlockAboutConfig = true;
      DefaultDownloadDirectory = "\${home}/Downloads";
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        "*" = {
          "installation_mode" = "blocked";
        };
        "uBlock0@raymondhill.net" = {
          installation_mode = "allowed";
        };
        "gdpr@cavi.au.dk" = {
          installation_mode = "allowed";
        };
        "{5cce4ab5-3d47-41b9-af5e-8203eea05245}" = {
          installation_mode = "allowed";
        };
        "plasma-browser-integration@kde.org" = {
          installation_mode = "allowed";
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          installation_mode = "allowed";
        };
        "firefoxpwa@filips.si" = {
          installation_mode = "allowed";
        };
        "sponsorBlocker@ajay.app" = {
          installation_mode = "allowed";
        };
        "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
          installation_mode = "allowed";
        };
        "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
          installation_mode = "allowed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "allowed";
        };
      };
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = false;
      DisableAccounts = false;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "always"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"
    };
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
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
            bitwarden
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

          # Undo a bunch of stuff that LibreWolf does
          # "browser.safebrowsing.malware.enabled" = true;
          # "browser.safebrowsing.phishing.enabled" = true;
          # "browser.safebrowsing.blockedURIs.enabled" = true;
          # "browser.safebrowsing.provider.google4.gethashURL" =
          #   "https://safebrowsing.googleapis.com/v4/fullHashes:find?$ct=application/x-protobuf&key=%GOOGLE_SAFEBROWSING_API_KEY%&$httpMethod=POST";
          # "browser.safebrowsing.provider.google4.updateURL" =
          #   "https://safebrowsing.googleapis.com/v4/threatListUpdates:fetch?$ct=application/x-protobuf&key=%GOOGLE_SAFEBROWSING_API_KEY%&$httpMethod=POST";
          # "browser.safebrowsing.provider.google.gethashURL" =
          #   "https://safebrowsing.google.com/safebrowsing/gethash?client=SAFEBROWSING_ID&appver=%MAJOR_VERSION%&pver=2.2";
          # "browser.safebrowsing.provider.google.updateURL" =
          #   "https://safebrowsing.google.com/safebrowsing/downloads?client=SAFEBROWSING_ID&appver=%MAJOR_VERSION%&pver=2.2&key=%GOOGLE_SAFEBROWSING_API_KEY%";
          # "browser.safebrowsing.downloads.enabled" = true;
          # "privacy.resistFingerprinting.letterboxing" = false;
          # "webgl.disabled" = false;
          # "identity.fxaccounts.enabled" = true;
          # "privacy.clearOnShutdown.history" = false;
          # "privacy.clearOnShutdown.downloads" = false;
          # "privacy.fingerprintingProtection" = false;
          # "network.cookie.lifetimePolicy" = 0;
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
