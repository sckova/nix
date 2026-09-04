# home/sckova/apps/firefox/theme.nix
{
  config,
  lib,
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
  flatten =
    prefix: attrs:
    lib.concatMapAttrs (
      name: value:
      let
        key = "${prefix}.${name}";
      in
      if builtins.isAttrs value then flatten key value else { ${key} = value; }
    ) attrs;
in
{
  home.file = {
    "${firefoxUserChromePath}/colors.css".text = with config.scheme.withHashtag; /* css */ ''
      @namespace xul url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");
      @media (prefers-color-scheme: dark) {
        :root {
          /* Palette */
          --gnome-palette-blue-1: ${base0D} !important;
          --gnome-palette-blue-2: ${base0D} !important;
          --gnome-palette-blue-3: ${base0D} !important;
          --gnome-palette-blue-4: ${base0D} !important;
          --gnome-palette-blue-5: ${base0D} !important;
          --gnome-palette-green-1: ${base0B} !important;
          --gnome-palette-green-2: ${base0B} !important;
          --gnome-palette-green-3: ${base0B} !important;
          --gnome-palette-green-4: ${base0B} !important;
          --gnome-palette-green-5: ${base0B} !important;
          --gnome-palette-yellow-1: ${base0A} !important;
          --gnome-palette-yellow-2: ${base0A} !important;
          --gnome-palette-yellow-3: ${base0A} !important;
          --gnome-palette-yellow-4: ${base0A} !important;
          --gnome-palette-yellow-5: ${base0A} !important;
          --gnome-palette-orange-1: ${base09} !important;
          --gnome-palette-orange-2: ${base09} !important;
          --gnome-palette-orange-3: ${base09} !important;
          --gnome-palette-orange-4: ${base09} !important;
          --gnome-palette-orange-5: ${base09} !important;
          --gnome-palette-red-1: ${base08} !important;
          --gnome-palette-red-2: ${base08} !important;
          --gnome-palette-red-3: ${base08} !important;
          --gnome-palette-red-4: ${base08} !important;
          --gnome-palette-red-5: ${base08} !important;
          --gnome-palette-purple-1: ${base0E} !important;
          --gnome-palette-purple-2: ${base0E} !important;
          --gnome-palette-purple-3: ${base0E} !important;
          --gnome-palette-purple-4: ${base0E} !important;
          --gnome-palette-purple-5: ${base0E} !important;
          --gnome-palette-brown-1: ${base08} !important;
          --gnome-palette-brown-2: ${base08} !important;
          --gnome-palette-brown-3: ${base08} !important;
          --gnome-palette-brown-4: ${base08} !important;
          --gnome-palette-brown-5: ${base08} !important;
          --gnome-palette-light-1: ${base05} !important;
          --gnome-palette-light-2: ${base05} !important;
          --gnome-palette-light-3: ${base05} !important;
          --gnome-palette-light-4: ${base05} !important;
          --gnome-palette-light-5: ${base05} !important;
          --gnome-palette-dark-1: ${base00} !important;
          --gnome-palette-dark-2: ${base00} !important;
          --gnome-palette-dark-3: ${base00} !important;
          --gnome-palette-dark-4: ${base00} !important;
          --gnome-palette-dark-5: ${base00} !important;
          /* Colors */
          --gnome-standalone-color-oklab: max(l, 0.85) a b;
          --gnome-destructive-bg: ${base08};
          --gnome-success-bg: ${base0B};
          --gnome-warning-bg: ${base0A};
          --gnome-error-bg: ${base08};
          --gnome-toolbar-star-button: var(--gnome-palette-yellow-1);
          /* Window */
          --gnome-window-background: color-mix(in srgb, ${base10} 90%, transparent);
          --gnome-window-color: ${base05};
          --gnome-view-background: color-mix(in srgb, ${base10} 90%, transparent);
          --gnome-sidebar-background: color-mix(in srgb, ${base01} 90%, transparent);
          --gnome-secondary-sidebar-background: ${base02};
          /* Card */
          --gnome-card-background: color-mix(in srgb, ${base06} 8%, transparent);
          --gnome-card-shade-color: color-mix(in srgb, ${base00} 36%, transparent);
          /* Menu */
          --gnome-menu-background: ${base02};
          /* Header bar */
          --gnome-headerbar-background: color-mix(
            in srgb,
            ${base10} 90%,
            transparent
          ) !important;
          --gnome-headerbar-shade-color: ${base00};
          /* Tabs */
          --gnome-tabbar-identity-color-blue: ${base16};
          --gnome-tabbar-identity-color-green: var(--gnome-palette-green-1);
          --gnome-tabbar-identity-color-yellow: var(--gnome-palette-yellow-2);
          --gnome-tabbar-identity-color-orange: var(--gnome-palette-orange-3);
          --gnome-tabbar-identity-color-red: var(--gnome-palette-red-1);
          --gnome-tabbar-identity-color-purple: var(--gnome-palette-purple-1);
          /* Miscellaneous */
          --gnome-shade-color: color-mix(in srgb, ${base00} 25%, transparent);
          /* Text color for Firefox Logo in new private tab */
          --gnome-private-wordmark: ${base07};
          /* New private tab background */
          --gnome-private-in-content-page-background: ${base00};
          /* Private browsing info box */
          --gnome-private-text-primary-color: ${base07};
          /* Backdrop colors */
          &:-moz-window-inactive {
            --gnome-sidebar-background: ${base10};
            --gnome-secondary-sidebar-background: ${base11};
          }
          /* Private browsing colors */
          &[privatebrowsingmode="temporary"] {
            /* Headerbar */
            --gnome-headerbar-background: color-mix(
              in srgb,
              ${base0E} 20%,
              ${base01}
            ) !important;
            &:-moz-window-inactive {
              --gnome-headerbar-background: color-mix(
                in srgb,
                ${base00} 90%,
                transparent
              ) !important;
            }
          }
        }
      }
    '';

    "${firefoxUserChromePath}/firefox-gnome-theme" = {
      recursive = true;
      source = inputs.firefox-gnome-theme;
    };

    "${firefoxUserChromePath}/userChrome.css".text = /* css */ ''
      @import "firefox-gnome-theme/userChrome.css";
      @import "colors.css";
      #toolbar-menubar {
        display: none !important;
      }

      #menubar-items {
        visibility: hidden !important;
      }
    '';

    "${firefoxUserChromePath}/userContent.css".text = /* css */ ''
      @import "firefox-gnome-theme/userContent.css";
    '';
  };

  # comments taken from the theme source code
  programs.firefox.profiles.default.settings = flatten "gnomeTheme" {
    # Add more contrast to the active tab.
    activeTabContrast = false;
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
    extensions.adaptiveTabBarColour = false;
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
