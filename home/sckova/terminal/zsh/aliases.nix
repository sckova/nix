# home/sckova/terminal/zsh/aliases.nix
{
  lib,
  pkgs,
  ...
}:
{
  home = {
    file.".local/share/bin/.keep".text = ""; # Ensure directory exists

    packages = [
      (pkgs.writeScriptBin "nix-format" /* zsh */ ''
        #!${pkgs.zsh}/bin/zsh
        set -euo pipefail

        target="''${1:-.}"
        local -a files=()

        if [[ -d "$target" ]]; then
          files=($target/**/*.nix(N.))
        elif [[ -f "$target" ]]; then
          files=("$target")
        else
          print -r -- "nix-format: '$target' is not a file or directory" >&2
          exit 1
        fi

        if (( ''${#files} == 0 )); then
          print -r -- "nix-format: no .nix files found under '$target'" >&2
          exit 0
        fi

        ${lib.getExe pkgs.nixfmt} "''${files[@]}"
        ${lib.getExe pkgs.pedantix} --formatter off "''${files[@]}"
        ${lib.getExe pkgs.nixfmt} "''${files[@]}"
      '')
    ];

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
