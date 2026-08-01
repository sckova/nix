# https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
{
  config,
  lib,
  pkgs,
  inputs,
  isLinux,
  ...
}:
let
  firefoxPath =
    if isLinux then
      "${config.xdg.configHome}/mozilla/firefox"
    else
      "${config.home.homeDirectory}/Library/Application Support/Firefox";
  firefoxProfilePath = if isLinux then firefoxPath else firefoxPath + "/Profiles";
in
{
  home.file = {
    ".local/share/firefoxpwa/profiles/01KEYXH9TC4B54J5CTPNE75JP0/prefs.js" = {
      force = true;

      text = /* js */ ''
        user_pref("firefoxpwa.alwaysUseNativeWindowControls", true);
        user_pref("firefoxpwa.displayUrlBar", 1);
        user_pref("firefoxpwa.enableHidingIconBar", true);
        user_pref("firefoxpwa.dynamicWindowTitle", true);
        user_pref("ui.key.menuAccessKeyFocuses", false);
        user_pref("browser.aboutConfig.showWarning", false);
        user_pref("browser.ml.enable", false);
      '';
    };

    # fix xdg data path differences
    ".mozilla/firefox" = {
      force = true;

      source =
        with config.lib.file;
        mkOutOfStoreSymlink "${config.home.homeDirectory}/${config.programs.firefox.configPath}";
    };
  };

  programs = {
    firefox = {
      enable = true;

      package =
        if isLinux then
          pkgs.firefox.override {
            nativeMessagingHosts = with pkgs; [
              firefoxpwa
            ];
          }
        else
          pkgs.firefox;

      configPath = firefoxPath;

      policies = {
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

        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # force declarative installation
          "ATBC@EasonWong".installation_mode = "allowed"; # adaptive tab bar color
          "CanvasBlocker@kkapsner.de".installation_mode = "allowed"; # canvas blocker
          "deArrow@ajay.app".installation_mode = "allowed"; # dearrow
          "firefoxpwa@filips.si".installation_mode = "allowed"; # firefoxpwa
          "gdpr@cavi.au.dk".installation_mode = "allowed"; # consent-o-matic
          "jid1-MnnxcxisBPnSXQ@jetpack".installation_mode = "allowed"; # privacy badger
          "shinigamieyes@shinigamieyes".installation_mode = "allowed"; # shinigami eyes
          "sponsorBlocker@ajay.app".installation_mode = "allowed"; # sponsor blocker
          "uBlock0@raymondhill.net".installation_mode = "allowed"; # ublock origin
          "{446900e4-71c2-419f-a6a7-df9c091e268b}".installation_mode = "allowed"; # bitwarden
          "{5cce4ab5-3d47-41b9-af5e-8203eea05245}".installation_mode = "allowed"; # control panel for twitter
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".installation_mode = "allowed"; # stylus
          "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}".installation_mode = "allowed"; # violentmonkey
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}".installation_mode = "allowed"; # vimium

          # https://addons.config/mozilla.org/en-US/firefox/addon/youtube-tweaks/
          "{d867162c-4c38-4c5f-aca4-db6a6592d7da}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4778682/latest.xpi";
            installation_mode = "force_installed"; # youtube tweaks
          };
        };

        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        SearchBar = "unified"; # alternative: "separate"
      };

      profiles.default = {
        bookmarks = {
          force = true;

          settings = [
            {
              bookmarks = [
                {
                  name = "NixOS";
                  url = "https://nixos.org/";
                }
                {
                  name = "Home Manager Appendix A";
                  url = "https://nix-community.github.io/home-manager/options.xhtml";
                }
                {
                  name = "NixOS config";
                  url = "https://ovips.us.to/git/sckova/nix";
                }
              ];

              name = "Nix sites";
              toolbar = true;
            }
          ];
        };

        extensions = {
          force = true;

          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
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
            vimium
            adaptive-tab-bar-colour
          ];

          settings = {
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
              force = true;
              settings.dbInChromeStorage = true;
            };

            "{d867162c-4c38-4c5f-aca4-db6a6592d7da}".settings = {
              alwaysShowProgBar = false;
              autoExpandComments = true;
              compactButtons = true;
              compactHeaderBar = false;
              compactLeftSidebar = true;
              customProgBar = "";
              darkThemes = "Catppuccin Mocha";
              decreaseFontSize = true;
              dimWatchVideos = "85-100%";
              dimWatchVideos2 = "85-100%";
              dimWatchVideos3 = "85-100%";
              dimWatchVideos4 = "85-100%";
              dimWatchVideos5 = "85-100%";
              fixChannelLinks = true;
              flipVideo = "";
              fullscreenTheaterMode = false;
              gridSearchResults = true;
              hideClipButton = true;
              hideControlsOnPause = false;
              hideDownloadButton = true;
              hideEndCards = "autoHide";
              hideExplore = true;
              hideLatestYouTubePosts = true;
              hideLiveStreams = "both";
              hideLiveStreams3 = "both";
              hideLiveStreams4 = "both";
              hideMixes = true;
              hideMixes2 = true;
              hideMixes3 = true;
              hideMoreFromYt = true;
              hideProfilePictures = true;
              hideRecommendationBar = true;
              hideRightSidebar = true;
              hideSaveButton = true;
              hideSearchResults = true;
              hideShareButton = false;
              hideShorts = true;
              hideShorts2 = true;
              hideShorts3 = true;
              hideShorts4 = true;
              hideShorts5 = true;
              hideShortsButton = true;
              hideThanksButton = true;
              hideUpcoming = true;
              hideUpcoming2 = true;
              hideUpcoming3 = true;
              hideWatchVideos = "";
              hideWatchVideos2 = "";
              hideWatchVideos3 = "";
              hideWatchVideos5 = "";
              keepProgBarAtBottom = false;
              maxNumOfColumns = "3";
              perChannelVideoSpeed = "";
              pinVideoOnScroll = "";
              progBarColor = "hsla(0; 100%; 50%; 1)";
              sResultsInNewTab = true;
              scrollUpButton = "";
              showFullVideoTitles = true;
              showProgBarOutsidePlayer = true;
              sidebarComments = "";
              vfBlur = 5;
              vfOpacity = 0.5;
              videoDescription = "Expanded";
              videoFocus = false;
              videoQuality = "highres";
              videoRemTime = false;
              videosAsDefaultTab = true;
              videosPerRow = true;
              vqFallback = "highest";
              watchVideoOpacity = 0.3;
              ytLogoSubsPage = false;
            };
          };
        };

        id = 0;
        isDefault = true;
        name = "default";

        search =
          let
            nixIcon = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            searchIcon = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/scalable/places/folder-saved-search-symbolic.svg";
          in
          {
            default = "searxng";

            engines = {
              nix-options = {
                definedAliases = [ "@no" ];
                icon = nixIcon;
                name = "Nix Options";

                urls = [
                  {
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

                    template = "https://search.nixos.org/options";
                  }
                ];
              };

              nix-packages = {
                definedAliases = [ "@np" ];
                icon = nixIcon;
                name = "Nix Packages";

                urls = [
                  {
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

                    template = "https://search.nixos.org/packages";
                  }
                ];
              };

              nixos-wiki = {
                definedAliases = [ "@nw" ];
                icon = nixIcon;
                name = "NixOS Wiki";
                urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              };

              searxng = {
                definedAliases = [ "@go" ];
                icon = searchIcon;
                name = "SearXNG";
                urls = [ { template = "http://localhost:5364/search?q={searchTerms}"; } ];
              };

              wikipedia = {
                definedAliases = [ "@wi" ];
                name = "Wikipedia";
                urls = [ { template = "https://en.wikipedia.org/w/index.php?search={searchTerms}"; } ];
              };
            };

            force = true;

            order = [
              "searxng"
            ];
          };

        settings = with config.fonts; {
          "browser.aboutConfig.showWarning" = false;
          "browser.ai.control.default" = "blocked";
          "browser.ai.control.linkPreviewKeyPoints" = "blocked";
          "browser.ai.control.pdfjsAltText" = "blocked";
          "browser.ai.control.sidebarChatbot" = "blocked";
          "browser.ai.control.smartTabGroups" = "blocked";
          "browser.ai.control.translations" = "blocked";
          "browser.cache.disk.enable" = true; # Set to false if you have a HDD
          "browser.compactmode.show" = true;

          "browser.contentblocking.category" = {
            Status = "locked";
            Value = "strict";
          };

          # Configure fonts
          "browser.display.use_document_fonts" = 0;
          "browser.download.autoHideButton" = false;
          "browser.formfill.enable" = false;
          "browser.ml.chat.enabled" = false;
          "browser.ml.chat.page" = false;
          # Disable Firefox's machine learning (AI) features
          "browser.ml.enable" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showWeather" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.search.defaultenginename" = "searxng";
          "browser.search.order.1" = "searxng";
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          "browser.startup.homepage" = "about:newtab";
          "browser.tabs.inTitlebar" = 2;
          "browser.tabs.splitview.enabled" = false;
          "browser.tabs.splitview.hasUsed" = true;
          # Disable private window dark theme
          "browser.theme.dark-private-windows" = false;
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "browser.topsites.contile.enabled" = false;

          "browser.uiCustomization.state" = {
            currentVersion = 24;

            dirtyAreaCache = [
              "unified-extensions-area"
              "nav-bar"
              "TabsToolbar"
              "vertical-tabs"
              "PersonalToolbar"
              "toolbar-menubar"
            ];

            newElementCount = 1;

            placements = {
              PersonalToolbar = [ "personal-bookmarks" ];
              TabsToolbar = [ ];

              nav-bar = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "customizableui-special-spring7"
                "urlbar-container"
                "customizableui-special-spring8"
                "unified-extensions-button"
                "downloads-button"
                "reset-pbm-toolbar-button"
                "vertical-spacer"
              ];

              toolbar-menubar = [ "menubar-items" ];

              unified-extensions-area = [
                "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
                "sponsorblocker_ajay_app-browser-action"
                "ublock0_raymondhill_net-browser-action"
                "jid1-mnnxcxisbpnsxq_jetpack-browser-action"
                "gdpr_cavi_au_dk-browser-action"
                "firefoxpwa_filips_si-browser-action"
                "canvasblocker_kkapsner_de-browser-action"
                "_5cce4ab5-3d47-41b9-af5e-8203eea05245_-browser-action"
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
                "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
                "_d867162c-4c38-4c5f-aca4-db6a6592d7da_-browser-action"
                "atbc_easonwong-browser-action"
              ];

              vertical-tabs = [ "tabbrowser-tabs" ];
              widget-overflow-fixed-list = [ ];
            };

            seen = [
              "gdpr_cavi_au_dk-browser-action"
              "firefoxpwa_filips_si-browser-action"
              "jid1-mnnxcxisbpnsxq_jetpack-browser-action"
              "canvasblocker_kkapsner_de-browser-action"
              "_5cce4ab5-3d47-41b9-af5e-8203eea05245_-browser-action"
              "ublock0_raymondhill_net-browser-action"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
              "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
              "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
              "sponsorblocker_ajay_app-browser-action"
              "developer-button"
              "reset-pbm-toolbar-button"
              "_d867162c-4c38-4c5f-aca4-db6a6592d7da_-browser-action"
              "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
              "atbc_easonwong-browser-action"
            ];
          };

          # Set UI density to normal
          "browser.uidensity" = 0;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.warnOnQuitShortcut" = false;
          # For browser toolbox/live editing user CSS
          "devtools.chrome.enabled" = true;
          "devtools.debugger.remote-enabled" = true;
          "extensions.autoDisableScopes" = 0; # enables all extensions automatically
          "extensions.pocket.enabled" = false;
          "extensions.screenshots.disabled" = true;
          "extensions.update.autoUpdateDefault" = false;
          "extensions.update.enabled" = false;
          "font.default.x-western" = "sans-serif";
          # use configured system fonts
          "font.name.monospace.x-western" = mono.name;
          "font.name.sans-serif.x-western" = sans.name;
          "font.name.serif.x-western" = serif.name;
          # these all seemingly only look good at this size
          "font.size.monospace.x-western" = 16;
          "font.size.sans-serif.x-western" = 16;
          "font.size.variable.x-western" = 16;
          "gnomeTheme.activeTabContrast" = true;
          "gnomeTheme.bookmarksToolbarUnderTabs" = true;
          "gnomeTheme.extensions.adaptiveTabBarColour" = true;
          "gnomeTheme.hideSingleTab" = true;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "privacy.resistFingerprinting" = false;
          "sidebar.notification.badge.aichat" = false;
          # Vertical tabs
          "sidebar.verticalTabs" = true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
          "signon.rememberSignons" = false;
          "svg.context-properties.content.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "webgl.disabled" = false;
          "widget.disable-workspace-management" = true;
          "widget.gtk.global-menu.enabled" = true;
          "widget.gtk.global-menu.wayland.enabled" = true;
          # Enable rounded bottom window corners (disable if WM handles it)
          "widget.gtk.rounded-bottom-corners.enabled" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "xpinstall.signatures.required" = false;
        };
      };
    };

    firefoxpwa = lib.mkIf isLinux {
      enable = true;

      profiles."01KEYXH9TC4B54J5CTPNE75JP0".sites."01KEYXHK7XQQJ0M3J7SX4VD9PG" = {
        desktopEntry = {
          categories = [
            "Network"
            "Chat"
            "Telephony"
          ];

          icon = "${pkgs.morewaita-icon-theme}/share/icons/MoreWaita/scalable/apps/whatsapp.svg";
        };

        manifestUrl = "https://web.whatsapp.com/data/manifest.json";
        name = "WhatsApp";
        url = "https://web.whatsapp.com/";
      };

      settings.config = {
        always_patch = false;
        runtime_enable_wayland = true;
        runtime_use_portals = true;
        runtime_use_xinput2 = true;
        use_linked_runtime = false;
      };
    };
  };

  xdg.configFile = {
    "mozilla/firefox/default/chrome/firefox-gnome-theme" = {
      recursive = true;
      source = inputs.firefox-gnome-theme;
    };

    "mozilla/firefox/default/chrome/userChrome.css".text = /* css */ ''
      @import "firefox-gnome-theme/userChrome.css";

      #toolbar-menubar {
        display: none !important;
      }

      #menubar-items {
        visibility: hidden !important;
      }

      /* apply 90% transparency to the frame */
      html > body {
        background: color-mix(
          in srgb,
          var(--toolbox-background-color) 90%,
          transparent
        ) !important;
      }
    '';

    "mozilla/firefox/default/chrome/userContent.css".text = /* css */ ''
      @import "firefox-gnome-theme/userContent.css";
    '';
  };
}
