{
  home.file.".config/zsh/binds.zsh".text = /* zsh */ ''
    TRAPINT() {
      zle kill-whole-line
      zle reset-prompt
      return 0
    }
  '';

  programs.zsh.initContent = /* zsh */ ''
    source ~/.config/zsh/binds.zsh
  '';
}
