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
        "1x".disabled = true;
        "artic".disabled = false;

        "bing" = {
          disabled = false;
          weight = 0.4;
        };

        "bing images".disabled = false;
        "bing videos".disabled = false;
        "brave".disabled = true;
        "brave.images".disabled = true;
        "brave.news".disabled = true;
        "brave.videos".disabled = true;

        "crowdview" = {
          disabled = false;
          weight = 0.5;
        };

        "curlie".disabled = true;
        "currency".disabled = true;
        "dailymotion".disabled = true;

        "ddg definitions" = {
          disabled = false;
          weight = 2;
        };

        "deviantart".disabled = false;
        "dictzone".disabled = true;
        "duckduckgo".disabled = false;
        "duckduckgo images".disabled = false;
        "duckduckgo videos".disabled = false;
        "flickr".disabled = true;

        "google" = {
          disabled = false;
          weight = 2.0;
        };

        "google images".disabled = false;
        "google news".disabled = true;
        "google play movies".disabled = true;
        "google videos".disabled = false;
        "imgur".disabled = false;
        "invidious".disabled = true;
        "library of congress".disabled = false;
        "lingva".disabled = true;

        "material icons" = {
          disabled = true;
          weight = 0.2;
        };

        "mojeek".disabled = true;

        "mwmbl" = {
          disabled = false;
          weight = 0.4;
        };

        "odysee".disabled = true;
        "openverse".disabled = false;
        "peertube".disabled = false;
        "pinterest".disabled = true;
        "piped".disabled = true;
        "qwant".disabled = true;
        "qwant images".disabled = true;
        "qwant videos".disabled = false;
        "rumble".disabled = false;
        "sepiasearch".disabled = false;

        "startpage" = {
          disabled = false;
          weight = 2.0;
        };

        "svgrepo".disabled = false;
        "unsplash".disabled = false;
        "vimeo".disabled = true;
        "wallhaven".disabled = false;
        "wikibooks".disabled = false;
        "wikicommons.images".disabled = false;
        "wikidata".disabled = true;
        "wikiquote".disabled = true;
        "wikisource".disabled = true;

        "wikispecies" = {
          disabled = false;
          weight = 0.5;
        };

        "wikiversity" = {
          disabled = false;
          weight = 0.5;
        };

        "wikivoyage" = {
          disabled = false;
          weight = 0.5;
        };

        "yacy images".disabled = true;
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
