{ inputs, ... }:
{
  programs.firefox.profiles.default.settings.gnomeTheme = {
    activeTabContrast = true;
    allTabsButtonOnOverflow = true;
    bookmarksToolbarUnderTabs = true;
    closeOnlySelectedTabs = true;
    extensions.adaptiveTabBarColour = true;
    hideSingleTab = true;
    hideUnifiedExtensions = false;
    symbolicTabIcons = false;
    systemIcons = true;
    tabAlignLeft = false;
    tabsAsHeaderbar = false;
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
