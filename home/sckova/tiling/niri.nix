{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
{
  # https://github.com/sodiboo/niri-flake/blob/main/docs.md
  # https://github.com/niri-wm/niri/wiki/
  # since niri-flake doesn't currently have many of the latest options, we write this directly
  home.file.".config/niri/config.kdl".text =
    let
      defaultOpacity = "0.90";
      ringColors = with config.scheme.withHashtag; {
        active = config.scheme.withHashtag.${config.colors.accent};
        inactive = base01;
        urgent = base12;
      };
      overviewPlusShadowColor = config.scheme.withHashtag.base11;
      cornerRadius = lib.strings.floatToString 8.0;
    in
    /* kdl */ ''
      // --- System & Startup ---
      ${if hostname == "peach" then ''debug { render-drm-device "/dev/dri/renderD128"; }'' else ""}

      spawn-at-startup "${pkgs.noctalia-shell}/bin/noctalia-shell"

      environment {
      	DISPLAY ":0"
      	XCURSOR_THEME "${config.userOptions.cursor.name}"
      	XCURSOR_SIZE "${toString config.userOptions.cursor.size}"
      }

      screenshot-path "~/Pictures/Screenshots/%a %b %e %Y @%l:%M %p.png"

      prefer-no-csd

      hotkey-overlay {
      	skip-at-startup
      }

      // --- Outputs ---
      output "eDP-1" {
      	scale 1.5
      	mode "3024x1964@120.000"
      	position x=272 y=1440
      }

      output "HDMI-A-1" {
      	scale 1.5
      	mode "3840x2160@144.000"
      	position x=0 y=0
      }

      output "DP-1" {
      	scale 1.5
      	mode "3840x2160@143.999"
      	position x=0 y=0
      }

      // --- Input ---
      input {
      	mod-key "Super"
      	
      	keyboard {
      	  repeat-delay 600
      	  repeat-rate 25
      	}
      	
      	mouse {
      	  accel-profile "adaptive"
      	}
      	
      	touchpad {
      	  accel-profile "adaptive"
      	  natural-scroll
      	  tap
      	  dwt
      	  drag true
      	}
      	
      	focus-follows-mouse max-scroll-amount="5%"
      }

      cursor {
      	xcursor-theme "${config.userOptions.cursor.name}"
      	xcursor-size ${toString config.userOptions.cursor.size}
      }

      // --- Layout ---
      overview {
      	backdrop-color "${overviewPlusShadowColor}"
      	workspace-shadow {
      	  off
      	}
      }

      layout {
      	background-color "transparent"
      	gaps 4
      	
      	preset-column-widths {
      	  proportion 0.33333
      	  proportion 0.50000
      	  proportion 0.66667
      	}
      	default-column-width { proportion 0.5; }

      	border {
      	  width 2
      	  active-color "${ringColors.active}"
      	  inactive-color "${ringColors.inactive}"
      	  urgent-color "${ringColors.urgent}"
      	}

      	focus-ring {
      	  off
      	  width 2
      	  active-color "${ringColors.active}"
      	  inactive-color "${ringColors.inactive}"
      	  urgent-color "${ringColors.urgent}"
      	}

      	shadow {
      	  on
      	  spread 5
      	  softness 10
      	  offset x=0 y=0
      	  color "${overviewPlusShadowColor}BF"
      	}

      	struts {
      	  top 46
      	}
      }

      // --- Rules ---
      window-rule {
      	geometry-corner-radius ${cornerRadius}
      	clip-to-geometry true
      	opacity ${defaultOpacity}
      	draw-border-with-background false
      	background-effect {
      	  xray false
      	  blur true
      	  noise 0.03
      	  saturation 1.0
      	}
      }

      window-rule {
      	match app-id="vesktop$"
      	match app-id="org.gnome.Nautilus$"
      	block-out-from "screen-capture"
      }

      window-rule {
      	match is-active=false
      	opacity 0.90
      }

      window-rule {
      	match app-id="openmw" title="OpenMW"
      	match app-id="Minecraft" title="Minecraft"
      	open-maximized-to-edges true
      	open-focused true
      	opacity 1.00
      }

      window-rule {
      	match app-id="firefox" title="Picture-in-Picture"
      	match app-id="" title="Picture in picture"
      	opacity 1.0
      }

      // Ghostty Fastfetch window
      window-rule {
      	match app-id="^com.mitchellh.ghostty$" title="^fastfetch$"
      	open-floating true
      	baba-is-float true
      	min-width 960
      	min-height 480
      	max-width 960
      	max-height 480
      }

      // for apps that can handle their own background opacity
      window-rule {
      	match app-id="^com.mitchellh.ghostty$"
      	match app-id="^org.gnome.Nautilus$"
      	match app-id="^mpv$" title=".* - mpv \\(nix\\)$"
      	match app-id="^org.gnome.Fractal$"
      	match app-id="^firefox$"
      	match app-id="^org.gnome.Snapshot$"
      	match app-id="^vicinae$"
      	opacity 1.0
      }

      layer-rule {
      	match namespace="^wallpaper$"
      	place-within-backdrop true
      }

      layer-rule {
      	match namespace="^noctalia-(background|launcher-overlay|dock)-.*$"
      	match namespace="vicinae"
      	background-effect {
      	  xray false
      	  blur true
      	  noise 0.03
      	  saturation 1.0
      	}
      }

      // --- Keybinds ---
      binds {
      	Mod+Shift+Slash { show-hotkey-overlay; }
      	Mod+D { toggle-window-rule-opacity; }
      	
      	Mod+M { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
      	Mod+T { spawn "${pkgs.ghostty}/bin/ghostty"; }
      	Mod+Space { spawn "${pkgs.vicinae}/bin/vicinae" "toggle"; }
      	
      	// Open a Terminal with Fastfetch
      	Mod+Shift+T { spawn "sh" "-c" "${pkgs.ghostty}/bin/ghostty --title='fastfetch' -e sh -c 'fastfetch; sleep 10'"; }

      	// --- Media Controls ---
      	XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
      	XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
      	Shift+XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.01+"; }
      	Shift+XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.01-"; }

      	MouseForward allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
      	MouseBack allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
      	Shift+MouseForward allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.01+"; }
      	Shift+MouseBack allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.01-"; }

      	XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      	XF86AudioMicMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      	XF86MonBrightnessUp allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "brightness" "increase"; }
      	XF86MonBrightnessDown allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "brightness" "decrease"; }
      	Shift+XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+1%"; }
      	Shift+XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "1%-"; }

      	XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }
      	XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
      	XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }

      	// --- Launchers & System ---
      	XF86Search { spawn "${pkgs.vicinae}/bin/vicinae"; }
      	Mod+Shift+L { spawn "${pkgs.swaylock}/bin/swaylock"; }
      	XF86LaunchA { toggle-overview; }
      	Mod+O { toggle-overview; }
      	XF86Sleep { power-off-monitors; }
      	Mod+Shift+P { power-off-monitors; }
      	Mod+Q { close-window; }
      	Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      	Mod+Shift+E { quit; }
      	Ctrl+Alt+Delete { quit; }

      	// --- Window & Column Management ---
      	Mod+Left { focus-column-left; }
      	Mod+Down { focus-window-down; }
      	Mod+Up { focus-window-up; }
      	Mod+Right { focus-column-right; }

      	Mod+Ctrl+Left { move-column-left; }
      	Mod+Ctrl+Down { move-window-down; }
      	Mod+Ctrl+Up { move-window-up; }
      	Mod+Ctrl+Right { move-column-right; }
      	Mod+Ctrl+H { move-column-left; }
      	Mod+Ctrl+J { move-window-down; }
      	Mod+Ctrl+K { move-window-up; }
      	Mod+Ctrl+L { move-column-right; }

      	Mod+Home { focus-column-first; }
      	Mod+End { focus-column-last; }
      	Mod+Ctrl+Home { move-column-to-first; }
      	Mod+Ctrl+End { move-column-to-last; }

      	Mod+BracketLeft { consume-or-expel-window-left; }
      	Mod+BracketRight { consume-or-expel-window-right; }
      	Mod+Comma { consume-window-into-column; }
      	Mod+Period { expel-window-from-column; }

      	Mod+R { switch-preset-column-width; }
      	Mod+Shift+R { switch-preset-window-height; }
      	Mod+Ctrl+R { reset-window-height; }
      	Mod+F { maximize-column; }
      	Mod+Shift+F { maximize-window-to-edges; }
      	Mod+Ctrl+Shift+F { fullscreen-window; }

      	Mod+C { center-column; }
      	Mod+Ctrl+C { center-visible-columns; }

      	Mod+Minus { set-column-width "-10%"; }
      	Mod+Equal { set-column-width "+10%"; }
      	Mod+Shift+Minus { set-window-height "-10%"; }
      	Mod+Shift+Equal { set-window-height "+10%"; }

      	Mod+Ctrl+Minus { set-column-width "-0.25%"; }
      	Mod+Ctrl+Equal { set-column-width "+0.25%"; }
      	Mod+Ctrl+Shift+Minus { set-window-height "-0.25%"; }
      	Mod+Ctrl+Shift+Equal { set-window-height "+0.25%"; }

      	Mod+V { toggle-window-floating; }
      	Mod+Shift+V { switch-focus-between-floating-and-tiling; }
      	Mod+W { toggle-column-tabbed-display; }

      	// --- Monitor Movement ---
      	Mod+Shift+Left { focus-monitor-left; }
      	Mod+Shift+Down { focus-monitor-down; }
      	Mod+Shift+Up { focus-monitor-up; }
      	Mod+Shift+Right { focus-monitor-right; }

      	Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
      	Mod+Shift+Ctrl+Down { move-column-to-monitor-down; }
      	Mod+Shift+Ctrl+Up { move-column-to-monitor-up; }
      	Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      	Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
      	Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
      	Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
      	Mod+Shift+Ctrl+L { move-column-to-monitor-right; }

      	// --- Workspaces ---
      	Mod+Page_Down { focus-workspace-down; }
      	Mod+Page_Up { focus-workspace-up; }
      	Mod+U { focus-workspace-down; }
      	Mod+I { focus-workspace-up; }
      	Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
      	Mod+Ctrl+Page_Up { move-column-to-workspace-up; }
      	Mod+Ctrl+U { move-column-to-workspace-down; }
      	Mod+Ctrl+I { move-column-to-workspace-up; }

      	Mod+Shift+Page_Down { move-workspace-down; }
      	Mod+Shift+Page_Up { move-workspace-up; }
      	Mod+Shift+U { move-workspace-down; }
      	Mod+Shift+I { move-workspace-up; }

      	Mod+1 { focus-workspace 1; }
      	Mod+2 { focus-workspace 2; }
      	Mod+3 { focus-workspace 3; }
      	Mod+4 { focus-workspace 4; }
      	Mod+5 { focus-workspace 5; }
      	Mod+6 { focus-workspace 6; }
      	Mod+7 { focus-workspace 7; }
      	Mod+8 { focus-workspace 8; }
      	Mod+9 { focus-workspace 9; }

      	Mod+Ctrl+1 { move-column-to-workspace 1; }
      	Mod+Ctrl+2 { move-column-to-workspace 2; }
      	Mod+Ctrl+3 { move-column-to-workspace 3; }
      	Mod+Ctrl+4 { move-column-to-workspace 4; }
      	Mod+Ctrl+5 { move-column-to-workspace 5; }
      	Mod+Ctrl+6 { move-column-to-workspace 6; }
      	Mod+Ctrl+7 { move-column-to-workspace 7; }
      	Mod+Ctrl+8 { move-column-to-workspace 8; }
      	Mod+Ctrl+9 { move-column-to-workspace 9; }

      	// --- Mouse Wheel & Scrolling Navigation ---
      	Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      	Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
      	Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      	Mod+Ctrl+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }

      	Mod+WheelScrollRight { focus-column-right; }
      	Mod+WheelScrollLeft { focus-column-left; }
      	Mod+Ctrl+WheelScrollRight { move-column-right; }
      	Mod+Ctrl+WheelScrollLeft { move-column-left; }

      	Mod+Shift+WheelScrollDown { focus-column-right; }
      	Mod+Shift+WheelScrollUp { focus-column-left; }
      	Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      	Mod+Ctrl+Shift+WheelScrollUp { move-column-left; }

      	// --- Screenshots ---
      	Mod+Shift+S { screenshot show-pointer=false; }
      	Ctrl+Shift+S { screenshot-screen show-pointer=false; }
      	Alt+Shift+S { screenshot-window show-pointer=false; }
      }
            		'';
}
