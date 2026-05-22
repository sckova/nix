{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    autoraise
    (aerospace.overrideAttrs (
      finalAttrs: previousAttrs: {
        version = "0.20.3-Beta";

        src = pkgs.fetchzip {
          url = "https://github.com/nikitabobko/AeroSpace/releases/download/v0.20.3-Beta/AeroSpace-v0.20.3-Beta.zip";
          sha256 = "sha256-wrBcslp1W/lOmudMcW+SREL9LZY+wTwidh6Hot5ShGE=";
        };
      }
    ))
  ];

  home.file.".local/share/bin/autoraise.sh" = {
    executable = true;
    text = with pkgs; /* bash */ ''
      while true; do
        ${tmux}/bin/tmux new-session -s autoraise '${autoraise}/bin/autoraise'
        sleep 1
      done
    '';
  };

  home.file.".AutoRaise".text = lib.generators.toKeyValue { } {
    pollMillis = 50;
    delay = 1;
    focusDelay = 2;
    warpX = 0.5;
    warpY = 0.1;
    scale = 2.5;
    altTaskSwitcher = false;
    requireMouseStop = true;
    ignoreSpaceChanged = false;
    invertDisableKey = false;
    invertIgnoreApps = false;
    ignoreApps = "\"\"";
    ignoreTitles = "\"\"";
    stayFocusedBundleIds = "\"\"";
    disableKey = "\"control\"";
    mouseDelta = 0.1;
  };

  home.file.".aerospace.toml".source = (pkgs.formats.toml { }).generate "aerospace.toml" {
    config-version = 2;
    after-startup-command = [ ];
    start-at-login = false;
    enable-normalization-flatten-containers = true;
    enable-normalization-opposite-orientation-for-nested-containers = true;

    # Niri uses a column proportion approach. Tiles is the closest equivalent.
    default-root-container-layout = "tiles";
    default-root-container-orientation = "auto";

    # Focus follows mouse enabled in niri
    on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
    automatically-unhide-macos-hidden-apps = false;

    # Matching Niri's gaps = 4
    gaps = {
      inner = {
        horizontal = 4;
        vertical = 4;
      };
      outer = {
        left = 4;
        bottom = 4;
        top = 4;
        right = 4;
      };
    };

    # Keybindings mimicking niri
    # Niri Mod -> alt
    # Niri Mod+Ctrl -> alt-ctrl
    # Niri Mod+Shift -> alt-shift
    mode.main.binding = {
      # App Launchers
      alt-t = "exec-and-forget open -a ghostty";
      alt-space = "exec-and-forget open -a Raycast"; # Replace with Spotlight/Alfred/Vicinae if ported
      alt-o = "exec-and-forget open -a 'Mission Control'"; # toggle-overview equivalent

      alt-leftSquareBracket = "join-with left";
      alt-rightSquareBracket = "join-with right";

      # Focus Window
      alt-left = "focus left";
      alt-down = "focus down";
      alt-up = "focus up";
      alt-right = "focus right";

      # Move Window
      alt-shift-left = "move left";
      alt-shift-down = "move down";
      alt-shift-up = "move up";
      alt-shift-right = "move right";
      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";

      # Move to Monitor
      alt-shift-ctrl-left = "move-node-to-monitor left";
      alt-shift-ctrl-down = "move-node-to-monitor down";
      alt-shift-ctrl-up = "move-node-to-monitor up";
      alt-shift-ctrl-right = "move-node-to-monitor right";
      alt-shift-ctrl-h = "move-node-to-monitor left";
      alt-shift-ctrl-j = "move-node-to-monitor down";
      alt-shift-ctrl-k = "move-node-to-monitor up";
      alt-shift-ctrl-l = "move-node-to-monitor right";

      # Workspaces Focus
      alt-pageDown = "workspace next";
      alt-pageUp = "workspace prev";
      alt-u = "workspace next";
      alt-i = "workspace prev";

      alt-1 = "workspace 1";
      alt-2 = "workspace 2";
      alt-3 = "workspace 3";

      # Move to Workspace
      alt-ctrl-pageDown = "move-node-to-workspace next";
      alt-ctrl-pageUp = "move-node-to-workspace prev";
      alt-ctrl-u = "move-node-to-workspace next";
      alt-ctrl-i = "move-node-to-workspace prev";

      alt-ctrl-1 = "move-node-to-workspace 1";
      alt-ctrl-2 = "move-node-to-workspace 2";
      alt-ctrl-3 = "move-node-to-workspace 3";
      alt-ctrl-4 = "move-node-to-workspace 4";
      alt-ctrl-5 = "move-node-to-workspace 5";
      alt-ctrl-6 = "move-node-to-workspace 6";
      alt-ctrl-7 = "move-node-to-workspace 7";
      alt-ctrl-8 = "move-node-to-workspace 8";
      alt-ctrl-9 = "move-node-to-workspace 9";

      # Layout, Toggling, and Sizing
      alt-minus = "resize smart -10";
      alt-equal = "resize smart +10";

      alt-f = "fullscreen"; # maximize-column equivalent
      alt-v = "layout floating tiling"; # toggle-window-floating equivalent
      alt-w = "layout accordion horizontal vertical"; # toggle-column-tabbed-display equivalent
      alt-c = "layout tiles horizontal vertical"; # center-column fallback

      # Niri's Mod+Shift+E for Quit
      alt-shift-e = [
        "reload-config"
        "mode main"
      ]; # Safe fallback, quits are handled by Cmd+Q on macOS
    };
  };
}
