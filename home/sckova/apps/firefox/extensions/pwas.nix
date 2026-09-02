# home/sckova/apps/firefox/extensions/pwas.nix
{
  lib,
  pkgs,
  isLinux,
  ...
}:
{
  home = {
    file.".local/share/firefoxpwa/profiles/01KEYXH9TC4B54J5CTPNE75JP0/prefs.js" = {
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

    packages = with pkgs; [ firefoxpwa ];
  };

  programs.firefoxpwa = lib.mkIf isLinux {
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
}
