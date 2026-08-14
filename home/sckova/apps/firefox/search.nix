{
  config,
  lib,
  pkgs,
  isLinux,
  ...
}:
let
  nixIcon = pkgs.runCommand "nix-snowflake.svg" { } ''
    sed 's/#ffffff/${config.scheme.withHashtag.base05}/g' \
      ${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg \
      > $out
  '';
  searchIcon = pkgs.runCommand "search-symbolic.svg" { } ''
    sed 's/#000000/${config.scheme.withHashtag.base05}/g' \
      ${pkgs.morewaita-icon-theme}/share/icons/MoreWaita/symbolic/status/search-symbolic.svg \
      > $out
  '';
in
{
  default = if isLinux then "searxng" else "duckduckgo";

  engines = {
    duckduckgo = {
      definedAliases = [ "@dd" ];
      icon = searchIcon;
      name = "DuckDuckGo";
      urls = [ { template = "https://duckduckgo.com/?t=ffab&q={searchTerms}&ia=web"; } ];
    };

    google = {
      definedAliases = [ "@go" ];
      icon = searchIcon;
      name = "Google (no LLM)";
      urls = [ { template = "https://www.google.com/search?q={searchTerms}&udm=14"; } ];
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

    searxng = lib.mkIf isLinux {
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
    "duckduckgo"
  ];
}
