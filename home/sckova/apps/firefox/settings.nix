{ config, ... }:
with config.fonts;
{
  browser = {
    aboutConfig.showWarning = false;

    ai.control = {
      default = "blocked";
      linkPreviewKeyPoints = "blocked";
      pdfjsAltText = "blocked";
      sidebarChatbot = "blocked";
      smartTabGroups = "blocked";
      translations = "blocked";
    };

    cache.disk.enable = true; # Set to false if you have a HDD
    compactmode.show = true;

    contentblocking.category = {
      Status = "locked";
      Value = "strict";
    };

    # Configure fonts
    display.use_document_fonts = 0;
    download.autoHideButton = false;
    formfill.enable = false;

    ml = {
      # Disable Firefox's machine learning (AI) features
      enable = false;

      chat = {
        enabled = false;
        page = false;
      };
    };

    newtabpage.activity-stream = {
      feeds = {
        section.topstories = false;
        snippets = false;
        topsites = false;
      };

      section.highlights = {
        includeBookmarks = false;
        includeDownloads = false;
        includePocket = false;
        includeVisited = false;
      };

      showSponsored = false;
      showSponsoredTopSites = false;
      showWeather = false;
      system.showSponsored = false;
    };

    search = {
      defaultenginename = "searxng";
      order."1" = "searxng";

      suggest = {
        enabled = false;
        "enabled.private" = false;
      };
    };

    startup.homepage = "about:newtab";

    tabs = {
      inTitlebar = 2;

      splitview = {
        enabled = false;
        hasUsed = true;
      };
    };

    # Disable private window dark theme
    theme.dark-private-windows = false;
    toolbars.bookmarks.visibility = "newtab";
    topsites.contile.enabled = false;

    uiCustomization.state = {
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
        unified-extensions-area = [ ];
        widget-overflow-fixed-list = [ ];
      };

      seen = [
        "developer-button"
        "reset-pbm-toolbar-button"
      ];
    };

    # Set UI density to normal
    uidensity = 0;

    urlbar = {
      showSearchSuggestionsFirst = false;
      suggest.searches = false;
    };

    warnOnQuitShortcut = false;
  };

  devtools = {
    # For browser toolbox/live editing user CSS
    chrome.enabled = true;
    debugger.remote-enabled = true;
  };

  extensions = {
    autoDisableScopes = 0; # enables all extensions automatically
    pocket.enabled = false;
    screenshots.disabled = true;

    update = {
      autoUpdateDefault = false;
      enabled = false;
    };
  };

  font = {
    default.x-western = "sans-serif";

    name = {
      # use configured system fonts
      monospace.x-western = mono.name;
      sans-serif.x-western = sans.name;
      serif.x-western = serif.name;
    };

    size = {
      # these all seemingly only look good at this size
      monospace.x-western = 16;
      sans-serif.x-western = 16;
      variable.x-western = 16;
    };
  };

  privacy = {
    clearOnShutdown = {
      downloads = false;
      history = false;
    };

    clearOnShutdown_v2.cookiesAndStorage = false;
    resistFingerprinting = false;
  };

  sidebar = {
    notification.badge.aichat = false;
    # Vertical tabs
    verticalTabs = false;
    "verticalTabs.dragToPinPromo.dismissed" = true;
  };

  signon.rememberSignons = false;
  svg.context-properties.content.enabled = true;
  toolkit.legacyUserProfileCustomizations.stylesheets = true;
  webgl.disabled = false;

  widget = {
    disable-workspace-management = true;

    gtk = {
      global-menu = {
        enabled = true;
        wayland.enabled = true;
      };

      # Enable rounded bottom window corners (disable if WM handles it)
      rounded-bottom-corners.enabled = false;
    };

    use-xdg-desktop-portal.file-picker = 1;
  };

  xpinstall.signatures.required = false;
}
