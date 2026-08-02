{ pkgs, ... }:
let
  nixIcon = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  searchIcon = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/scalable/places/folder-saved-search-symbolic.svg";
in
{
  default = "searxng";

  engines = {
    google = {
      definedAliases = [ "goog" ];
      icon = searchIcon;
      name = "Google";
      urls = [ { template = "https://www.google.com/search?q={searchTerms}"; } ];
    };

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
      definedAliases = [ "@se" ];
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
}
