# home/sckova/apps/discord/default.nix
{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./settings.nix
  ];

  home.packages = with pkgs; [
    vesktop
  ];

  # vesktop daemon that runs at login
  systemd.user.services.vesktop = {
    Install.WantedBy = [ "niri.service" ];

    Service = {
      ExecStart = lib.getExe pkgs.vesktop + " -m";
      ExecStartPre = "-" + pkgs.procps + "/bin/pkill -9 -x vesktop";
      ExecStopPost = "-" + pkgs.procps + "/bin/pkill -9 -x vesktop";
      Restart = "on-failure";
    };

    Unit = {
      After = [ "niri.service" ];
      Description = "Vesktop daemon";
    };
  };
}
