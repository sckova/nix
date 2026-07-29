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
      ".config/mozilla"
      ".config/gh"
      ".local/share/PrismLauncher"
      ".local/share/fish"
      ".local/share/wallpaper"
      ".config/age"
      ".config/openmw"
      ".local/share/openmw"
    ];

    hideMounts = true;
  };
}
