# https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
{
  pkgs,
  config,
  ...
}:
{
  home.file.".mozilla/firefox/default/chrome/" = {
    source = ./firefox_css;
    force = true;
    recursive = true;
  };

  home.file.".mozilla/firefox/default/chrome/colors.css" = {
    text =
      let
        toRgb =
          prefix:
          "rgb(${toString config.scheme."${prefix}-rgb-r"},${toString config.scheme."${prefix}-rgb-g"},${
            toString config.scheme."${prefix}-rgb-b"
          })";
      in
      /* css */ ''
        * {
          --accent: ${toRgb config.colors.accent};
          --base00: ${toRgb "base00"}; /* base */
          --base01: ${toRgb "base01"}; /* surface0 */
          --base02: ${toRgb "base02"}; /* surface1 */
          --base03: ${toRgb "base03"}; /* overlay0 */
          --base04: ${toRgb "base04"}; /* subtext0 */
          --base05: ${toRgb "base05"}; /* text */
          --base06: ${toRgb "base06"}; /* rosewater */
          --base07: ${toRgb "base07"}; /* lavender */
          --base08: ${toRgb "base08"}; /* red */
          --base09: ${toRgb "base09"}; /* peach */
          --base0A: ${toRgb "base0A"}; /* yellow */
          --base0B: ${toRgb "base0B"}; /* green */
          --base0C: ${toRgb "base0C"}; /* teal */
          --base0D: ${toRgb "base0D"}; /* blue */
          --base0E: ${toRgb "base0E"}; /* mauve */
          --base0F: ${toRgb "base0F"}; /* flamingo */
          --base10: ${toRgb "base10"}; /* mantle - darker background */
          --base11: ${toRgb "base11"}; /* crust - darkest background */
          --base12: ${toRgb "base12"}; /* maroon - bright red */
          --base13: ${toRgb "base13"}; /* rosewater - bright yellow */
          --base14: ${toRgb "base14"}; /* green - bright green */
          --base15: ${toRgb "base15"}; /* sky - bright cyan */
          --base16: ${toRgb "base16"}; /* sapphire - bright blue */
          --base17: ${toRgb "base17"}; /* pink - bright purple */
        }
      '';
    force = true;
  };

  home.file.".local/share/firefoxpwa/profiles/01KEYXH9TC4B54J5CTPNE75JP0/prefs.js" = {
    text = /* js */ ''
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
            icon = "${pkgs.morewaita-icon-theme}/share/icons/MoreWaita/scalable/apps/whatsapp.svg";
            categories = [
              "Network"
              "Chat"
              "Telephony"
            ];
          };
        };
      };
    };
    firefox = {
      enable = true;
      # trace: evaluation warning: sckova profile: The default value of
      # `programs.firefox.configPath` has changed from `".mozilla/firefox"` to
      # `"${config.xdg.configHome}/mozilla/firefox"`.

      # You are currently using the legacy default (`".mozilla/firefox"`)
      # because `home.stateVersion` is less than "26.05".

      # To silence this warning and keep legacy behavior, set:
      #   programs.firefox.configPath = ".mozilla/firefox";
      # To adopt the new default behavior, set:
      #   programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

      # To migrate to the XDG path, move `~/.mozilla/firefox` to
      # `$XDG_CONFIG_HOME/mozilla/firefox` and remove the old directory.
      # Native messaging hosts are not moved by this option change.
      configPath = ".mozilla/firefox";
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
          "*".installation_mode = "blocked";
          "uBlock0@raymondhill.net".installation_mode = "allowed";
          "gdpr@cavi.au.dk".installation_mode = "allowed";
          "{5cce4ab5-3d47-41b9-af5e-8203eea05245}".installation_mode = "allowed";
          "jid1-MnnxcxisBPnSXQ@jetpack".installation_mode = "allowed";
          "firefoxpwa@filips.si".installation_mode = "allowed";
          "sponsorBlocker@ajay.app".installation_mode = "allowed";
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".installation_mode = "allowed";
          "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}".installation_mode = "allowed";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}".installation_mode = "allowed";
          "CanvasBlocker@kkapsner.de".installation_mode = "allowed";
          "shinigamieyes@shinigamieyes".installation_mode = "allowed";
          "deArrow@ajay.app".installation_mode = "allowed";

          # https://addons.mozilla.org/en-US/firefox/addon/youtube-tweaks/
          "{d867162c-4c38-4c5f-aca4-db6a6592d7da}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4778682/latest.xpi";
            installation_mode = "force_installed";
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
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
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
              dearrow
            ];
            settings = {
              "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
                force = true;
                settings = {
                  dbInChromeStorage = true;
                };
              };
              "{d867162c-4c38-4c5f-aca4-db6a6592d7da}".settings = {
                videosPerRow = true;
                maxNumOfColumns = "3";
                hideProfilePictures = true;
                decreaseFontSize = true;
                hideShorts = true;
                hideWatchVideos = "";
                hideMixes = true;
                hideLiveStreams = "both";
                hideUpcoming = true;
                hideRecommendationBar = true;
                hideLatestYouTubePosts = true;
                dimWatchVideos = "85-100%";
                watchVideoOpacity = 0.3;
                hideShorts2 = true;
                hideWatchVideos2 = "";
                hideUpcoming2 = true;
                dimWatchVideos2 = "85-100%";
                videosAsDefaultTab = true;
                hideShorts3 = true;
                hideWatchVideos5 = "";
                dimWatchVideos5 = "85-100%";
                videoQuality = "highres";
                vqFallback = "highest";
                perChannelVideoSpeed = false;
                videoFocus = false;
                vfBlur = 5;
                vfOpacity = 0.5;
                flipVideo = false;
                videoRemTime = false;
                alwaysShowProgBar = true;
                keepProgBarAtBottom = false;
                showProgBarOutsidePlayer = true;
                customProgBar = "";
                pinVideoOnScroll = false;
                fullscreenTheaterMode = true;
                videoDescription = "Expanded";
                hideEndCards = "autoHide";
                hideControlsOnPause = false;
                autoExpandComments = true;
                sidebarComments = false;
                fixChannelLinks = true;
                hideShorts4 = true;
                hideWatchVideos3 = "";
                hideMixes2 = true;
                hideLiveStreams3 = "both";
                hideShareButton = true;
                hideDownloadButton = true;
                hideClipButton = true;
                hideThanksButton = true;
                hideSaveButton = true;
                compactButtons = true;
                dimWatchVideos3 = "85-100%";
                gridSearchResults = true;
                hideRightSidebar = true;
                hideShorts5 = true;
                hideMixes3 = true;
                hideLiveStreams4 = "both";
                hideUpcoming3 = true;
                hideSearchResults = true;
                dimWatchVideos4 = "85-100%";
                compactHeaderBar = false;
                sResultsInNewTab = true;
                compactLeftSidebar = true;
                showFullVideoTitles = true;
                scrollUpButton = "";
              };
            };
          };
          settings = {
            "extensions.autoDisableScopes" = 0; # enables all extensions automatically
            "xpinstall.signatures.required" = false;
            "extensions.update.autoUpdateDefault" = false;
            "extensions.update.enabled" = false;
            "browser.search.defaultenginename" = "searxng";
            "browser.search.order.1" = "searxng";
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
            "browser.download.autoHideButton" = false;
            "browser.startup.homepage" = "about:newtab";
            "browser.tabs.splitview.hasUsed" = true;

            # Configure fonts
            "browser.display.use_document_fonts" = 0;
            "font.default.x-western" = "sans-serif";
            "font.name.monospace.x-western" = config.userOptions.fontMono.name;
            "font.name.sans-serif.x-western" = config.userOptions.fontSans.name;
            "font.name.serif.x-western" = config.userOptions.fontSerif.name;
            # these all seemingly only look good at this size
            "font.size.monospace.x-western" = 16;
            "font.size.sans-serif.x-western" = 16;
            "font.size.variable.x-western" = 16;

            # Disable Firefox's machine learning (AI) features
            "browser.ml.enable" = false;
            "browser.ml.chat.enabled" = false;
            "browser.ml.chat.page" = false;
            "browser.ai.control.default" = "blocked";
            "browser.ai.control.linkPreviewKeyPoints" = "blocked";
            "browser.ai.control.pdfjsAltText" = "blocked";
            "browser.ai.control.sidebarChatbot" = "blocked";
            "browser.ai.control.smartTabGroups" = "blocked";
            "browser.ai.control.translations" = "blocked";
            "sidebar.notification.badge.aichat" = false;

            # For browser toolbox/live editing user CSS
            "devtools.chrome.enabled" = true;
            "devtools.debugger.remote-enabled" = true;

            # Vertical tabs
            "sidebar.verticalTabs" = true;
            "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
            "browser.uiCustomization.state" = {
              placements = {
                widget-overflow-fixed-list = [ ];
                unified-extensions-area = [
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
                  "dearrow_ajay_app-browser-action"
                ];
                nav-bar = [
                  # "sidebar-button"
                  "back-button"
                  "forward-button"
                  "stop-reload-button"
                  "urlbar-container"
                  "unified-extensions-button"
                  "downloads-button"
                ];
                toolbar-menubar = [ "menubar-items" ];
                TabsToolbar = [ ];
                vertical-tabs = [ "tabbrowser-tabs" ];
                PersonalToolbar = [ "personal-bookmarks" ];
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
                "dearrow_ajay_app-browser-action"
                "developer-button"
              ];
              dirtyAreaCache = [
                "unified-extensions-area"
                "nav-bar"
                "TabsToolbar"
                "vertical-tabs"
                "PersonalToolbar"
                "toolbar-menubar"
              ];
              currentVersion = 23;
              newElementCount = 1;
            };

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
                  {
                    name = "NixOS config";
                    url = "https://ovips.us.to/git/sckova/nix";
                  }
                ];
              }
            ];
          };
          search =
            let
              nixIcon = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              searchIcon = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/scalable/places/folder-saved-search-symbolic.svg";
            in
            {
              force = true;
              default = "searxng";
              order = [
                "searxng"
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
                  definedAliases = [ "@np" ];
                };

                nix-options = {
                  name = "Nix Options";
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
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
                  definedAliases = [ "@no" ];
                };

                nixos-wiki = {
                  name = "NixOS Wiki";
                  urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                  icon = nixIcon;
                  definedAliases = [ "@nw" ];
                };

                searxng = {
                  name = "SearXNG";
                  urls = [ { template = "http://localhost:5364/search?q={searchTerms}"; } ];
                  icon = searchIcon;
                  definedAliases = [ "@go" ];
                };

                wikipedia = {
                  name = "Wikipedia";
                  urls = [ { template = "https://en.wikipedia.org/w/index.php?search={searchTerms}"; } ];
                  definedAliases = [ "@wi" ];
                };
              };
            };
        };
      };
    };
  };
}
