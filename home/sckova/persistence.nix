{
  home.persistence."/persist" = {
    directories = [
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Projects"
      "Videos"
      {
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
      ".mozilla"
      ".cache/spotifyd" # credentials are stored here
      ".cache/spotify-player" # ...and here
      ".config/mozilla"
      ".config/gh"
      ".config/net.imput.helium"
      ".local/share/PrismLauncher"
      ".local/share/fish"
      ".local/share/wallpaper"
      ".local/share/fractal"
      ".local/share/folks"
      ".local/share/openmw"
      ".local/share/Steam"
      ".local/share/Archipelago"
      ".local/share/Celeste"
      ".local/share/soh"
      ".local/share/Paradox Interactive"
      ".local/share/"
      ".config/age"
      ".config/openmw"
    ];

    hideMounts = true;
  };
}
