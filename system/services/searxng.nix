# system/services/searxng.nix
{
  config,
  lib,
  hostname,
  ...
}:
{
  services.searx = {
    enable = true;
    environmentFile = config.sops.templates."searxng.env".path;
    redisCreateLocally = true;

    settings = {
      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];

      engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
        "1x".disabled = false;
        "artic".disabled = false;
        "bing".disabled = false;
        "bing images".disabled = false;
        "bing videos".disabled = false;
        "brave".disabled = false;
        "brave.images".disabled = false;
        "brave.news".disabled = false;
        "brave.videos".disabled = false;
        "crowdview".disabled = false;
        "curlie".disabled = false;
        "currency".disabled = false;
        "dailymotion".disabled = false;
        "ddg definitions".disabled = false;
        "deviantart".disabled = false;
        "dictzone".disabled = false;
        "duckduckgo".disabled = false;
        "duckduckgo images".disabled = false;
        "duckduckgo videos".disabled = false;
        "flickr".disabled = false;
        "google".disabled = false;
        "google images".disabled = false;
        "google news".disabled = false;
        "google play movies".disabled = false;
        "google videos".disabled = false;
        "imgur".disabled = false;
        "invidious".disabled = false;
        "library of congress".disabled = false;
        "lingva".disabled = false;
        "material icons".disabled = false;
        "mojeek".disabled = false;
        "mwmbl".disabled = false;
        "odysee".disabled = false;
        "openverse".disabled = false;
        "peertube".disabled = false;
        "pinterest".disabled = false;
        "piped".disabled = false;
        "qwant".disabled = false;
        "qwant images".disabled = false;
        "qwant videos".disabled = false;
        "rumble".disabled = false;
        "sepiasearch".disabled = false;
        "startpage".disabled = false;
        "svgrepo".disabled = false;
        "unsplash".disabled = false;
        "vimeo".disabled = false;
        "wallhaven".disabled = false;
        "wikibooks".disabled = false;
        "wikicommons.images".disabled = false;
        "wikidata".disabled = false;
        "wikiquote".disabled = false;
        "wikisource".disabled = false;
        "wikispecies".disabled = false;
        "wikiversity".disabled = false;
        "wikivoyage".disabled = false;
        "yacy images".disabled = false;
        "youtube".disabled = false;
      };

      general = {
        contact_url = false;
        debug = false;
        donation_url = false;
        enable_metrics = false;
        instance_name = "searxng: ${hostname}";
        privacypolicy_url = false;
      };

      search = {
        autocomplete = "duckduckgo";
        autocomplete_min = 2;
        ban_time_on_fail = 5;

        formats = [
          "html"
          "json"
          "rss"
        ];

        max_ban_time_on_fail = 120;
        safe_search = 2;
      };

      server = {
        bind_address = if hostname == "alien" then "0.0.0.0" else "127.0.0.1";
        port = 5364;
      };

      ui = {
        center_alignment = true;
        default_locale = "en";
        default_theme = "simple";
        hotkeys = "vim";
        infinite_scroll = true;
        query_in_title = true;
        search_on_category_select = false;
        static_use_hash = true;
        theme_args.simple_style = "auto";
      };
    };
  };

  sops.templates."searxng.env".content = /* bash */ ''
    SEARXNG_SECRET=${config.sops.placeholder.searxng_secret}
  '';
}
