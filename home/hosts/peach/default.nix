{
  lib,
  pkgs,
  ...
}:
{
  colors = {
    accent = "base09";
    scheme = "catppuccin-mocha";
  };

  home.packages = with pkgs; [
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync
  ];

  systemd.user.services.yabd = {
    Install.WantedBy = [ "niri.service" ];

    Service.ExecStart = /* bash */ ''
      ${lib.getExe pkgs.yabd} run \
        --device apple-panel-bl \
        --min-brightness 5.0
    '';

    Unit = {
      After = [ "niri.service" ];
      Description = "Automatic brightness utility";
      PartOf = [ "niri.service" ];
    };
  };
}
