{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./gtk.nix
    ./qt.nix
    ./systemd.nix
  ];

  home.file = {
    ".icons/default/index.theme" = {
      text = ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${config.userOptions.cursor.name}
      '';
      force = true;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = config.userOptions.cursor.name;
    package = config.userOptions.cursor.package;
    size = config.userOptions.cursor.size;
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    # this makes electron apps work per the wiki
    NIXOS_OZONE_WL = "1";
  };

  gtk = {
    enable = true;

    # colorScheme = if config.userOptions.isDark then "dark" else "light";

    # theme = {
    #   package = pkgs.kdePackages.breeze-gtk;
    #   name =
    #     if config.userOptions.isDark
    #     then "Breeze-Dark"
    #     else "Breeze";
    # };

    # iconTheme = {
    #   name = if config.userOptions.isDark then "Colloid-Dark" else "Colloid-Light";
    #   package = pkgs.colloid-icon-theme;
    # };

    colorScheme = "dark";
    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };

    cursorTheme = {
      name = config.home.pointerCursor.name;
      package = config.home.pointerCursor.package;
      size = config.home.pointerCursor.size;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = ":";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = ":";
    };
  };
}
