# home/sckova/apps/ghostty.nix
{
  config,
  lib,
  pkgs,
  isLinux,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = with pkgs; if isLinux then ghostty else ghostty-bin;
    enableZshIntegration = true;

    settings = {
      background-blur = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "macos-glass-clear";
      background-opacity = if isLinux then 0 else 0.9;
      confirm-close-surface = if isLinux then false else true;
      # https://github.com/ghostty-org/ghostty/discussions/5948
      font-family = config.fonts.mono.name;
      font-size = with config.fonts.mono; if isLinux then size else size + 1;

      keybind = [
        "ctrl+k=clear_screen"
        "ctrl+enter=unbind"
        # emit ^W instead of ^H for shell deletion
        "ctrl+backspace=text:\\x17"
      ];

      mouse-hide-while-typing = true;
      mouse-scroll-multiplier = lib.mkIf isLinux "precision:0.25,discrete:0.5";
      # https://ghostty.org/docs/linux/systemd
      quit-after-last-window-closed = lib.mkIf isLinux false;

      # comments taken from:
      # https://ghostty.org/docs/config/reference#shell-integration-features
      shell-integration-features = builtins.concatStringsSep "," [
        "cursor" # Set the cursor to a bar at the prompt.
        "sudo" # Set sudo wrapper to preserve terminfo.
        "title" # Set the window title via shell integration.
        "ssh-env" # Enable SSH environment variable compatibility.
        "ssh-terminfo" # Enable automatic terminfo installation on remote hosts.
        "path" # Add Ghostty's binary directory to PATH.
      ];

      theme = "nixos";
      window-padding-x = if isLinux then 4 else 8;
      window-padding-y = if isLinux then 4 else 8;
    };

    systemd.enable = lib.mkIf isLinux true;

    themes.nixos = with config.scheme.withHashtag; {
      background = base00;
      cursor-color = base05;
      cursor-text = base00;
      foreground = base05;

      palette = [
        "0=${base02}"
        "1=${base08}"
        "2=${base0B}"
        "3=${base0A}"
        "4=${base0D}"
        "5=${base17}"
        "6=${base0C}"
        "7=${base04}"
        "8=${base02}"
        "9=${base08}"
        "10=${base0B}"
        "11=${base0A}"
        "12=${base0D}"
        "13=${base17}"
        "14=${base0C}"
        "15=${base04}"
      ];
    };
  };
}
