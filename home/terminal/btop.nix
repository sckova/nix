{
  config,
  pkgs,
  ...
}:
let
  btop-colors = with config.scheme.withHashtag; ''
    # Credit to https://github.com/catppuccin/btop
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="${base00}"

    # Main text color
    theme[main_fg]="${base05}"

    # Title color for boxes
    theme[title]="${base05}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="${base0D}"

    # Background color of selected item in processes box
    theme[selected_bg]="${base02}"

    # Foreground color of selected item in processes box
    theme[selected_fg]="${base0D}"

    # Color of inactive/disabled text
    theme[inactive_fg]="${base03}"

    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="${base06}"

    # Background color of the percentage meters
    theme[meter_bg]="${base02}"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="${base06}"

    # CPU, Memory, Network, Proc box outline colors
    theme[cpu_box]="${base0E}" #Mauve
    theme[mem_box]="${base0B}" #Green
    theme[net_box]="${base12}" #Maroon
    theme[proc_box]="${base0D}" #Blue

    # Box divider line and small boxes line color
    theme[div_line]="${base03}"

    # Temperature graph color (Green -> Yellow -> Red)
    theme[temp_start]="${base0B}"
    theme[temp_mid]="${base0A}"
    theme[temp_end]="${base08}"

    # CPU graph colors (Teal -> Lavender)
    theme[cpu_start]="${base0C}"
    theme[cpu_mid]="${base16}"
    theme[cpu_end]="${base07}"

    # Mem/Disk free meter (Mauve -> Lavender -> Blue)
    theme[free_start]="${base0E}"
    theme[free_mid]="${base07}"
    theme[free_end]="${base0D}"

    # Mem/Disk cached meter (Sapphire -> Lavender)
    theme[cached_start]="${base16}"
    theme[cached_mid]="${base0D}"
    theme[cached_end]="${base07}"

    # Mem/Disk available meter (Peach -> Red)
    theme[available_start]="${base09}"
    theme[available_mid]="${base12}"
    theme[available_end]="${base08}"

    # Mem/Disk used meter (Green -> Sky)
    theme[used_start]="${base0B}"
    theme[used_mid]="${base0C}"
    theme[used_end]="${base15}"

    # Download graph colors (Peach -> Red)
    theme[download_start]="${base09}"
    theme[download_mid]="${base12}"
    theme[download_end]="${base08}"

    # Upload graph colors (Green -> Sky)
    theme[upload_start]="${base0B}"
    theme[upload_mid]="${base0C}"
    theme[upload_end]="${base15}"

    # Process box color gradient for threads, mem and cpu usage (Sapphire -> Mauve)
    theme[process_start]="${base16}"
    theme[process_mid]="${base07}"
    theme[process_end]="${base0E}"
  '';

  btop-colors-file = pkgs.writeTextFile {
    name = "btop-colors";
    text = btop-colors;
    destination = "/nixos.theme";
  };

  mergedConfig = pkgs.runCommand "mergedConfig" { } ''
    mkdir -p $out/themes
    cp -r ${btop-colors-file}/nixos.theme $out/themes/nixos.theme
  '';
in
{
  home.file.".config/btop" = {
    source = mergedConfig;
    recursive = true;
  };
}
