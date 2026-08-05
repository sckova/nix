{
  config,
  lib,
  ...
}:
let
  # Recursively turns a nested attrset into dotted-key Firefox prefs, since
  # about:config/prefs.js only stores flat scalars. `stopAt` lists dotted
  # paths where recursion should NOT descend. The value is left as an
  # attrs and gets JSON-encoded by home-manager's own settings serializer.
  # This matches prefs Firefox itself stores as JSON, e.g. browser.uiCustomization.state.
  flatten =
    stopAt: prefix: attrs:
    lib.concatMapAttrs (
      name: value:
      let
        key = if prefix == "" then name else "${prefix}.${name}";
      in
      if builtins.isAttrs value && !(builtins.elem key stopAt) then
        flatten stopAt key value
      else
        { ${key} = value; }
    ) attrs;
in
with config.fonts;
flatten [ "browser.uiCustomization.state" ] "" {
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

    # Check about:support for extension/add-on ID strings.
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
        TabsToolbar = [ "tabbrowser-tabs" ];

        nav-bar = [
          "sidebar-button"
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

        # Check about:support for extension/add-on ID strings.
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

        vertical-tabs = [ ];
        widget-overflow-fixed-list = [ ];
      };
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
