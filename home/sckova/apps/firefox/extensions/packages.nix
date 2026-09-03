# home/sckova/apps/firefox/extensions/packages.nix
{
  pkgs,
  ...
}:
{
  force = true;

  packages = with pkgs.nur.repos.rycee.firefox-addons; [
    bitwarden
    canvasblocker
    consent-o-matic
    control-panel-for-twitter
    iina-open-in-mpv
    privacy-badger
    pwas-for-firefox
    shinigami-eyes
    sponsorblock
    stylus
    ublock-origin
    vimium
    violentmonkey
  ];
}
