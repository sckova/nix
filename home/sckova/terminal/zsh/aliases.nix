# home/sckova/terminal/zsh/aliases.nix
{

  home = {
    file.".local/share/bin/.keep".text = ""; # Ensure directory exists

    sessionPath = [
      "$HOME/.local/share/bin"
    ];

    shellAliases = {
      ":q" = "exit";
      cat = "bat";
      ga = "git add -v .";
      gac = "git add -v . && git commit";
      gaca = "git add -v . && git commit --amend --no-edit";
      gd = "git diff";
      gl = "git log";
      gp = "git push";
      gpf = "git push --force";
      gzip = "pigz";
      ls = "eza";
    };
  };
}
