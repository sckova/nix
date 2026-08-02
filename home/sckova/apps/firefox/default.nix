# https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
{
  config,
  pkgs,
  isLinux,
  ...
}:
{
  imports = [
    ./extensions/pwas.nix
    ./theme.nix
  ];

  # fix xdg data path differences
  home.file.".mozilla/firefox" = {
    force = true;

    source =
      with config.lib.file;
      mkOutOfStoreSymlink "${config.home.homeDirectory}/${config.programs.firefox.configPath}";
  };

  programs.firefox = {
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

    configPath =
      if isLinux then
        "${config.xdg.configHome}/mozilla/firefox"
      else
        "${config.home.homeDirectory}/Library/Application Support/Firefox";

    policies = import ./policies.nix // {
      ExtensionSettings = import ./extensions/policies.nix;
    };

    profiles.default = {
      bookmarks = import ./bookmarks.nix;

      extensions = import ./extensions/packages.nix { inherit pkgs; } // {
        settings = import ./extensions/settings.nix;
      };

      id = 0;
      isDefault = true;
      name = "default";
      search = import ./search.nix { inherit pkgs; };

      settings = import ./settings.nix { inherit config; } // {
        browser.uiCustomization.state = import ./extensions/state.nix;
      };
    };
  };
}
