# home/sckova/apps/firefox/extensions/policies.nix
# Check about:support for extension/add-on ID strings.
# Valid strings for installation_mode are "allowed", "blocked",
# "force_installed" and "normal_installed".
{
  "*".installation_mode = "blocked"; # force declarative installation
  "CanvasBlocker@kkapsner.de".installation_mode = "allowed"; # canvas blocker
  "deArrow@ajay.app".installation_mode = "allowed"; # dearrow
  "firefoxpwa@filips.si".installation_mode = "allowed"; # firefoxpwa
  "gdpr@cavi.au.dk".installation_mode = "allowed"; # consent-o-matic
  "jid1-MnnxcxisBPnSXQ@jetpack".installation_mode = "allowed"; # privacy badger
  "shinigamieyes@shinigamieyes".installation_mode = "allowed"; # shinigami eyes
  "sponsorBlocker@ajay.app".installation_mode = "allowed"; # sponsor blocker
  "uBlock0@raymondhill.net".installation_mode = "allowed"; # ublock origin
  "{446900e4-71c2-419f-a6a7-df9c091e268b}".installation_mode = "allowed"; # bitwarden
  "{5cce4ab5-3d47-41b9-af5e-8203eea05245}".installation_mode = "allowed"; # control panel for twitter
  "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".installation_mode = "allowed"; # stylus
  "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}".installation_mode = "allowed"; # violentmonkey
  "{d66c8515-1e0d-408f-82ee-2682f2362726}".installation_mode = "allowed"; # iina-open-in-mpv
  "{d7742d87-e61d-4b78-b8a1-b469842139fa}".installation_mode = "allowed"; # vimium

  # https://addons.config/mozilla.org/en-US/firefox/addon/youtube-tweaks/
  "{d867162c-4c38-4c5f-aca4-db6a6592d7da}" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/4778682/latest.xpi";
    installation_mode = "force_installed"; # youtube tweaks
  };
}
