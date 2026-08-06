{
  config,
  inputs,
  isLinux,
  ...
}:
let
  userChromePath =
    with config.home;
    if isLinux then
      "${homeDirectory}/.thunderbird/default/chrome"
    else
      "${homeDirectory}/Library/Application Support/Thunderbird/Profiles/default/chrome";
in
{
  home.file = {
    "${userChromePath}/thunderbird-gnome-theme" = {
      recursive = true;
      source = inputs.thunderbird-gnome-theme;
    };

    "${userChromePath}/userChrome.css".text = /* css */ ''
      @import "thunderbird-gnome-theme/userChrome.css";
    '';

    "${userChromePath}/userContent.css".text = /* css */ ''
      @import "thunderbird-gnome-theme/userContent.css";
    '';
  };

  programs.thunderbird = {
    enable = true;

    profiles.default = {
      extraConfig = /* js */ ''
        user_pref("svg.context-properties.content.enabled", true);
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
      '';

      isDefault = true;
    };
  };
}
