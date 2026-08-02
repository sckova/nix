{
  pkgs,
  ...
}:
{
  force = true;

  packages = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    stylus
    violentmonkey
    consent-o-matic
    privacy-badger
    sponsorblock
    pwas-for-firefox
    control-panel-for-twitter
    bitwarden
    canvasblocker
    shinigami-eyes
    vimium
    adaptive-tab-bar-colour
  ];
}
