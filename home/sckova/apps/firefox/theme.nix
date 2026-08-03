{
  config,
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
  firefoxUserChromePath =
    if isLinux then firefoxPath + "/default/chrome" else firefoxPath + "/Profiles/default/chrome";
in
{
  home.file = {
    "${firefoxUserChromePath}/firefox-gnome-theme" = {
      recursive = true;
      source = inputs.firefox-gnome-theme;
    };

    "${firefoxUserChromePath}/userChrome.css".text = /* css */ ''
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

    "${firefoxUserChromePath}/userContent.css".text = /* css */ ''
      @import "firefox-gnome-theme/userContent.css";
    '';
  };

  # comments taken from the theme source code
  programs.firefox.profiles.default.settings.gnomeTheme = {
    activeTabContrast = true;
    # Show the List All Tabs button all the time, like stock Firefox.
    allTabsButton = false;
    # Show the List All Tabs button when the tabs bar is overflowing
    # (when you have too many tabs that the width of the tabs no longer
    # shrinks when new tabs are added).
    allTabsButtonOnOverflow = true;
    # Show the bookmarks bar while in fullscreen.
    bookmarksOnFullscreen = false;
    # Move Bookmarks toolbar under tabs.
    bookmarksToolbarUnderTabs = true;
    # Show the close button on the selected tab only.
    closeOnlySelectedTabs = false;
    # Allow dragging the window from headerbar buttons.
    dragWindowHeaderbarButtons = false;
    # Adaptive Tab Bar Colour support.
    extensions.adaptiveTabBarColour = true;
    # Hide the tab bar when only one tab is open.
    hideSingleTab = true;
    # Hide unified extensions button from the navbar.
    hideUnifiedExtensions = false;
    # Hide redundant WebRTC indicator since GNOME
    # provides their own privacy icons in the top right.
    hideWebrtcIndicator = false;
    # Use default Firefox icons instead of the included icons.
    noThemedIcons = false;
    # Use normal width tabs as default Firefox.
    normalWidthTabs = false;
    # Change the dark theme into the black variant.
    oledBlack = false;
    # By default the tab close buttons follows the position of
    # the window controls, this preference reverts that behavior.
    swapTabClose = false;
    # Make all tab icons look kinda like symbolic icons.
    symbolicTabIcons = false;
    # Use system theme icons instead of Adwaita icons included by theme.
    systemIcons = false;
    # Align the tab title and favicon to left of tab in place of center.
    tabAlignLeft = false;
    # Place the tabs on the top of the window, and use the tabs bar
    # to hold the window controls, like Firefox's standard tab bar.
    tabsAsHeaderbar = false;
  };
}
