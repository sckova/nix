# https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
{
  pkgs,
  config,
  lib,
  ...
}:

{
  home.file.".mozilla/firefox/default/chrome/theme" = {
    source = ./chrome/theme;
    force = true;
    recursive = true;
  };

  home.file.".mozilla/firefox/default/chrome/userChrome.css" = {
    source = ./chrome/userChrome.css;
    force = true;
  };

  home.file.".mozilla/firefox/default/chrome/colors.css" = {
    text = ''
      * {
        --accent: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.${config.catppuccin.accent}};
        --rosewater: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.rosewater};
        --flamingo: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.flamingo};
        --pink: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.pink};
        --mauve: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.mauve};
        --red: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.red};
        --maroon: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.maroon};
        --peach: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.peach};
        --yellow: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.yellow};
        --green: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.green};
        --teal: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.teal};
        --sky: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.sky};
        --sapphire: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.sapphire};
        --blue: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.blue};
        --lavender: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.lavender};
        --text: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.text};
        --subtext1: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.subtext1};
        --subtext0: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.subtext0};
        --overlay2: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.overlay2};
        --overlay1: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.overlay1};
        --overlay0: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.overlay0};
        --surface2: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.surface2};
        --surface1: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.surface1};
        --surface0: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.surface0};
        --base: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.base};
        --mantle: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.mantle};
        --crust: ${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.crust};
      }
    '';
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
      BlockAboutConfig = false;
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
        "{FirefoxColor@mozilla.com}" = {
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
            firefox-color
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

          # Disable Firefox's machine learning (AI) features
          "browser.ml.enable" = false;

          # For browser toolbox/live editing user CSS
          "devtools.chrome.enabled" = true;
          "devtools.debugger.remote-enabled" = true;

          # Vertical tabs
          "sidebar.verticalTabs" = true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
          # these are ordered right to left for some fucking reason
          "browser.uiCustomization.navBarWhenVerticalTabs" = [
            "unified-extensions-button"
            "fxa-toolbar-menu-button"
            "downloads-button"
            "urlbar-container"
            "stop-reload-button"
            "forward-button"
            "back-button"
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
                {
                  name = "Home Manager Appendix A";
                  url = "https://nix-community.github.io/home-manager/options.xhtml";
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
