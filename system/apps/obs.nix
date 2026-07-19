{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
  };

  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
  ];
}
