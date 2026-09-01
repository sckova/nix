# home/sckova/terminal/zsh/binds.nix
{
  home.file.".config/zsh/binds.zsh".text = /* zsh */ ''
    TRAPINT() {
      zle kill-whole-line
      zle reset-prompt
      return 0
    }

    WORDCHARS=''${WORDCHARS//\//}
  '';

  programs.zsh.initContent = /* zsh */ ''
    source ~/.config/zsh/binds.zsh
  '';
}
