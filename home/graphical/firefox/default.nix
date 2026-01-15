# https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
{
  pkgs,
  config,
  ...
}: {
  home.file.".librewolf/default/chrome/" = {
    source = ./chrome;
    force = true;
    recursive = true;
  };

  home.file.".librewolf/default/chrome/colors.css" = let
    color = pkgs.catppuccin.rgb.${config.catppuccin.flavor};
    accent = color.${config.catppuccin.accent};
  in {
    text = ''
      * {
        --accent: ${accent};
        --rosewater: ${color.rosewater};
        --flamingo: ${color.flamingo};
        --pink: ${color.pink};
        --mauve: ${color.mauve};
        --red: ${color.red};
        --maroon: ${color.maroon};
        --peach: ${color.peach};
        --yellow: ${color.yellow};
        --green: ${color.green};
        --teal: ${color.teal};
        --sky: ${color.sky};
        --sapphire: ${color.sapphire};
        --blue: ${color.blue};
        --lavender: ${color.lavender};
        --text: ${color.text};
        --subtext1: ${color.subtext1};
        --subtext0: ${color.subtext0};
        --overlay2: ${color.overlay2};
        --overlay1: ${color.overlay1};
        --overlay0: ${color.overlay0};
        --surface2: ${color.surface2};
        --surface1: ${color.surface1};
        --surface0: ${color.surface0};
        --base: ${color.base};
        --mantle: ${color.mantle};
        --crust: ${color.crust};
      }
    '';
    force = true;
  };

  home.file.".local/share/firefoxpwa/profiles/01KEYXH9TC4B54J5CTPNE75JP0/prefs.js" = {
    text = ''
      user_pref("firefoxpwa.alwaysUseNativeWindowControls", true);
      user_pref("firefoxpwa.displayUrlBar", 1);
      user_pref("firefoxpwa.enableHidingIconBar", true);
      user_pref("firefoxpwa.dynamicWindowTitle", true);
      user_pref("ui.key.menuAccessKeyFocuses", false);
      user_pref("browser.aboutConfig.showWarning", false);
      user_pref("browser.ml.enable", false);
    '';
    force = true;
  };

  programs = {
    firefoxpwa = {
      enable = true;
      settings.config = {
        always_patch = false;
        runtime_enable_wayland = true;
        runtime_use_xinput2 = true;
        runtime_use_portals = true;
        use_linked_runtime = false;
      };
      profiles = {
        "01KEYXH9TC4B54J5CTPNE75JP0".sites."01KEYXHK7XQQJ0M3J7SX4VD9PG" = {
          name = "WhatsApp";
          url = "https://web.whatsapp.com/";
          manifestUrl = "https://web.whatsapp.com/data/manifest.json";
          desktopEntry = {
            icon = "${pkgs.colloid-icon-theme}/share/icons/Colloid/apps/scalable/whatsapp.svg";
            categories = [
              "Network"
              "Chat"
              "Telephony"
            ];
          };
        };
      };
    };
    librewolf = {
      enable = true;
      package = pkgs.librewolf.override {
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
          "*".installation_mode = "blocked";
          "uBlock0@raymondhill.net".installation_mode = "allowed";
          "gdpr@cavi.au.dk".installation_mode = "allowed";
          "{5cce4ab5-3d47-41b9-af5e-8203eea05245}".installation_mode = "allowed";
          "plasma-browser-integration@kde.org".installation_mode = "allowed";
          "jid1-MnnxcxisBPnSXQ@jetpack".installation_mode = "allowed";
          "firefoxpwa@filips.si".installation_mode = "allowed";
          "sponsorBlocker@ajay.app".installation_mode = "allowed";
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".installation_mode = "allowed";
          "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}".installation_mode = "allowed";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}".installation_mode = "allowed";
          "CanvasBlocker@kkapsner.de".installation_mode = "allowed";
          "shinigamieyes@shinigamieyes".installation_mode = "allowed";
          # "".installation_mode = "allowed";
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
              canvasblocker
              shinigami-eyes
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
            "browser.uiCustomization.navBarWhenVerticalTabs" = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "reload-button"
              "urlbar-container"
              "downloads-button"
              "unified-extensions-button"
              "fxa-toolbar-menu-button"
            ];

            "privacy.resistFingerprinting" = false;
            "privacy.clearOnShutdown.history" = false;
            "privacy.clearOnShutdown.downloads" = false;
            "webgl.disabled" = false;
            "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
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
          search = let
            nixIcon = "${pkgs.colloid-icon-theme}/share/icons/Colloid/apps/scalable/nix-snowflake.svg";
            googleIcon = "${pkgs.colloid-icon-theme}/share/icons/Colloid/apps/scalable/google.svg";
          in {
            force = true;
            default = "google";
            order = [
              "google"
            ];
            engines = {
              nix-packages = {
                name = "Nix Packages";
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = nixIcon;
                definedAliases = ["@np"];
              };

              nixos-wiki = {
                name = "NixOS Wiki";
                urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
                icon = nixIcon;
                definedAliases = ["@nw"];
              };

              google = {
                name = "Google";
                urls = [{template = "https://google.com/search?q={searchTerms}";}];
                icon = googleIcon;
                definedAliases = ["@go"];
              };

              wikipedia = {
                name = "Wikipedia";
                urls = [{template = "https://en.wikipedia.org/w/index.php?search={searchTerms}";}];
                definedAliases = ["@wi"];
              };
            };
          };
        };
      };
    };
  };
}
