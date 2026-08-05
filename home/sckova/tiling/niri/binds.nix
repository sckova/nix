{
  config,
  lib,
  pkgs,
}:
{
  "Alt+Shift+S".screenshot-window._props.show-pointer = false;
  "Ctrl+Alt+Delete".quit = { };
  "Ctrl+Shift+S".screenshot-screen._props.show-pointer = false;

  "Ctrl+Shift+XF86AudioLowerVolume".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SOURCE@"
    "0.01-"
  ];

  "Ctrl+Shift+XF86AudioRaiseVolume".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SOURCE@"
    "0.01+"
  ];

  "Ctrl+Shift+XF86MonBrightnessDown".spawn._args = [
    "${pkgs.brightnessctl}/bin/brightnessctl"
    "-d"
    "kbd_backlight"
    "-c"
    "leds"
    "set"
    "1%-"
  ];

  "Ctrl+Shift+XF86MonBrightnessUp".spawn._args = [
    "${pkgs.brightnessctl}/bin/brightnessctl"
    "-d"
    "kbd_backlight"
    "-c"
    "leds"
    "set"
    "+1%"
  ];

  "Ctrl+XF86AudioLowerVolume".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SOURCE@"
    "0.05-"
  ];

  "Ctrl+XF86AudioMute".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-mute"
    "@DEFAULT_AUDIO_SOURCE@"
    "toggle"
  ];

  "Ctrl+XF86AudioRaiseVolume".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SOURCE@"
    "0.05+"
  ];

  "Ctrl+XF86MonBrightnessDown".spawn._args = [
    "${pkgs.brightnessctl}/bin/brightnessctl"
    "-d"
    "kbd_backlight"
    "-c"
    "leds"
    "set"
    "5%-"
  ];

  "Ctrl+XF86MonBrightnessUp".spawn._args = [
    "${pkgs.brightnessctl}/bin/brightnessctl"
    "-d"
    "kbd_backlight"
    "-c"
    "leds"
    "set"
    "+5%"
  ];

  "Mod+1".focus-workspace._args = [ 1 ];
  "Mod+2".focus-workspace._args = [ 2 ];
  "Mod+3".focus-workspace._args = [ 3 ];
  "Mod+4".focus-workspace._args = [ 4 ];
  "Mod+5".focus-workspace._args = [ 5 ];
  "Mod+6".focus-workspace._args = [ 6 ];
  "Mod+7".focus-workspace._args = [ 7 ];
  "Mod+8".focus-workspace._args = [ 8 ];
  "Mod+9".focus-workspace._args = [ 9 ];
  "Mod+BracketLeft".consume-or-expel-window-left = { };
  "Mod+BracketRight".consume-or-expel-window-right = { };
  "Mod+C".center-column = { };
  "Mod+Comma".consume-window-into-column = { };
  "Mod+Ctrl+1".move-column-to-workspace._args = [ 1 ];
  "Mod+Ctrl+2".move-column-to-workspace._args = [ 2 ];
  "Mod+Ctrl+3".move-column-to-workspace._args = [ 3 ];
  "Mod+Ctrl+4".move-column-to-workspace._args = [ 4 ];
  "Mod+Ctrl+5".move-column-to-workspace._args = [ 5 ];
  "Mod+Ctrl+6".move-column-to-workspace._args = [ 6 ];
  "Mod+Ctrl+7".move-column-to-workspace._args = [ 7 ];
  "Mod+Ctrl+8".move-column-to-workspace._args = [ 8 ];
  "Mod+Ctrl+9".move-column-to-workspace._args = [ 9 ];
  "Mod+Ctrl+C".center-visible-columns = { };
  "Mod+Ctrl+Down".move-window-down = { };
  "Mod+Ctrl+End".move-column-to-last = { };
  "Mod+Ctrl+Equal".set-column-width._args = [ "+0.25%" ];
  "Mod+Ctrl+H".move-column-left = { };
  "Mod+Ctrl+Home".move-column-to-first = { };
  "Mod+Ctrl+I".move-column-to-workspace-up = { };
  "Mod+Ctrl+J".move-window-down = { };
  "Mod+Ctrl+K".move-window-up = { };
  "Mod+Ctrl+L".move-column-right = { };
  "Mod+Ctrl+Left".move-column-left = { };
  "Mod+Ctrl+Minus".set-column-width._args = [ "-0.25%" ];
  "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
  "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
  "Mod+Ctrl+R".reset-window-height = { };
  "Mod+Ctrl+Right".move-column-right = { };
  "Mod+Ctrl+Shift+Equal".set-window-height._args = [ "+0.25%" ];
  "Mod+Ctrl+Shift+F".fullscreen-window = { };
  "Mod+Ctrl+Shift+Minus".set-window-height._args = [ "-0.25%" ];
  "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = { };
  "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = { };
  "Mod+Ctrl+U".move-column-to-workspace-down = { };
  "Mod+Ctrl+Up".move-window-up = { };

  "Mod+Ctrl+WheelScrollDown" = {
    _props.cooldown-ms = 150;
    move-column-to-workspace-down = { };
  };

  "Mod+Ctrl+WheelScrollLeft".move-column-left = { };
  "Mod+Ctrl+WheelScrollRight".move-column-right = { };

  "Mod+Ctrl+WheelScrollUp" = {
    _props.cooldown-ms = 150;
    move-column-to-workspace-up = { };
  };

  "Mod+D".toggle-window-rule-opacity = { };
  "Mod+Down".focus-window-down = { };
  "Mod+End".focus-column-last = { };
  "Mod+Equal".set-column-width._args = [ "+10%" ];

  "Mod+Escape" = {
    _props.allow-inhibiting = false;
    toggle-keyboard-shortcuts-inhibit = { };
  };

  "Mod+F".maximize-column = { };
  "Mod+Home".focus-column-first = { };
  "Mod+I".focus-workspace-up = { };
  # --- Window & Column Management ---
  "Mod+Left".focus-column-left = { };
  "Mod+Minus".set-column-width._args = [ "-10%" ];
  "Mod+O".toggle-overview = { };
  # --- Workspaces ---
  "Mod+Page_Down".focus-workspace-down = { };
  "Mod+Page_Up".focus-workspace-up = { };
  "Mod+Period".expel-window-from-column = { };
  "Mod+Q".close-window = { };
  "Mod+R".switch-preset-column-width = { };
  "Mod+Right".focus-column-right = { };
  "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
  "Mod+Shift+Ctrl+H".move-column-to-monitor-left = { };
  "Mod+Shift+Ctrl+J".move-column-to-monitor-down = { };
  "Mod+Shift+Ctrl+K".move-column-to-monitor-up = { };
  "Mod+Shift+Ctrl+L".move-column-to-monitor-right = { };
  "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
  "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
  "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
  "Mod+Shift+Down".focus-monitor-down = { };
  "Mod+Shift+E".quit = { };
  "Mod+Shift+Equal".set-window-height._args = [ "+10%" ];
  "Mod+Shift+F".maximize-window-to-edges = { };
  "Mod+Shift+I".move-workspace-up = { };
  "Mod+Shift+L".spawn._args = [ (lib.getExe config.programs.swaylock.package) ];
  # --- Monitor Movement ---
  "Mod+Shift+Left".focus-monitor-left = { };
  "Mod+Shift+Minus".set-window-height._args = [ "-10%" ];
  "Mod+Shift+P".power-off-monitors = { };
  "Mod+Shift+Page_Down".move-workspace-down = { };
  "Mod+Shift+Page_Up".move-workspace-up = { };
  "Mod+Shift+R".switch-preset-window-height = { };
  "Mod+Shift+Right".focus-monitor-right = { };
  # --- Screenshots ---
  "Mod+Shift+S".screenshot._props.show-pointer = false;
  "Mod+Shift+Slash".show-hotkey-overlay = { };

  # Open a Terminal with Fastfetch
  "Mod+Shift+T".spawn._args = [
    "sh"
    "-c"
    "${pkgs.ghostty}/bin/ghostty --title='fastfetch' -e sh -c 'fastfetch; sleep 10'"
  ];

  "Mod+Shift+U".move-workspace-down = { };
  "Mod+Shift+Up".focus-monitor-up = { };
  "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
  "Mod+Shift+WheelScrollDown".focus-column-right = { };
  "Mod+Shift+WheelScrollUp".focus-column-left = { };

  "Mod+Space".spawn._args = [
    "${pkgs.vicinae}/bin/vicinae"
    "toggle"
  ];

  "Mod+T".spawn._args = [ "${pkgs.ghostty}/bin/ghostty" ];
  "Mod+U".focus-workspace-down = { };
  "Mod+Up".focus-window-up = { };
  "Mod+V".toggle-window-floating = { };
  "Mod+W".toggle-column-tabbed-display = { };

  # --- Mouse Wheel & Scrolling Navigation ---
  "Mod+WheelScrollDown" = {
    _props.cooldown-ms = 150;
    focus-workspace-down = { };
  };

  "Mod+WheelScrollLeft".focus-column-left = { };
  "Mod+WheelScrollRight".focus-column-right = { };

  "Mod+WheelScrollUp" = {
    _props.cooldown-ms = 150;
    focus-workspace-up = { };
  };

  "MouseBack".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SINK@"
    "0.05-"
  ];

  "MouseForward".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SINK@"
    "0.05+"
  ];

  "Shift+MouseBack".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SINK@"
    "0.01-"
  ];

  "Shift+MouseForward".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SINK@"
    "0.01+"
  ];

  "Shift+XF86AudioLowerVolume".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SINK@"
    "0.01-"
  ];

  "Shift+XF86AudioRaiseVolume".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SINK@"
    "0.01+"
  ];

  "Shift+XF86MonBrightnessDown".spawn._args = [
    "${pkgs.noctalia}/bin/noctalia"
    "msg"
    "brightness-down"
    "all"
    "1"
  ];

  "Shift+XF86MonBrightnessUp".spawn._args = [
    "${pkgs.noctalia}/bin/noctalia"
    "msg"
    "brightness-up"
    "all"
    "1"
  ];

  "XF86AudioLowerVolume".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SINK@"
    "0.05-"
  ];

  "XF86AudioMicMute".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-mute"
    "@DEFAULT_AUDIO_SOURCE@"
    "toggle"
  ];

  "XF86AudioMute".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-mute"
    "@DEFAULT_AUDIO_SINK@"
    "toggle"
  ];

  "XF86AudioNext".spawn._args = [
    "${pkgs.playerctl}/bin/playerctl"
    "next"
  ];

  "XF86AudioPlay".spawn._args = [
    "${pkgs.playerctl}/bin/playerctl"
    "play-pause"
  ];

  "XF86AudioPrev".spawn._args = [
    "${pkgs.playerctl}/bin/playerctl"
    "previous"
  ];

  # --- Media Controls ---
  "XF86AudioRaiseVolume".spawn._args = [
    "${pkgs.wireplumber}/bin/wpctl"
    "set-volume"
    "@DEFAULT_AUDIO_SINK@"
    "0.05+"
  ];

  "XF86LaunchA".toggle-overview = { };

  "XF86MonBrightnessDown".spawn._args = [
    "${pkgs.noctalia}/bin/noctalia"
    "msg"
    "brightness-down"
    "all"
    "5"
  ];

  "XF86MonBrightnessUp".spawn._args = [
    "${pkgs.noctalia}/bin/noctalia"
    "msg"
    "brightness-up"
    "all"
    "5"
  ];

  # --- Launchers & System ---
  "XF86Search".spawn._args = [ "${pkgs.vicinae}/bin/vicinae" ];
  "XF86Sleep".power-off-monitors = { };
}
