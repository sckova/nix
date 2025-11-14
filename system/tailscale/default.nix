# https://github.com/tailscale/tailscale/issues/11504#issuecomment-2113331262
{
  config,
  pkgs,
  lib,
  ...
}:

let
  tailscaleWaitScript = pkgs.writeShellScript "tailscale-wait-for-ip" ''
    echo "Waiting for tailscale0 to get an IP address..."
    for i in {1..15}; do
      if ${lib.getExe' pkgs.iproute2 "ip"} addr show dev tailscale0 2>/dev/null | ${lib.getExe' pkgs.gnugrep "grep"} -q 'inet '; then
        echo "tailscale0 has IP address"
        exit 0
      fi
      echo "Attempt $i"
      sleep 1
    done
    echo "Warning: tailscale0 did not get IP address within 15 seconds"
    exit 0
  '';
in
{
  systemd.services.tailscaled = {
    serviceConfig = {
      ExecStartPost = tailscaleWaitScript;
    };
  };
}
