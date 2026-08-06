{
  xdg.desktopEntries.nvim = {
    categories = [
      "Utility"
      "TextEditor"
    ];

    comment = "Edit text files in your terminal";
    exec = "ghostty --class=nvim -e nvim %F";
    genericName = "Text Editor";
    icon = "nvim";

    mimeType = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
      "text/markdown"
      "application/json"
    ];

    name = "Neovim";
    terminal = false;
    type = "Application";
  };
}
