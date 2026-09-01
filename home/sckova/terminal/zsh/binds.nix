# home/sckova/terminal/zsh/binds.nix
{
  home.file.".config/zsh/binds.zsh".text = /* zsh */ ''
    # load zpty module
    zmodload zsh/zpty

    # ctrl+c clear without newline
    TRAPINT() {
      zle kill-whole-line
      zle reset-prompt
      return 0
    }

    # more fish-like word deletion
    WORDCHARS=''${WORDCHARS//\//}

    # binds with zsh-history-substring-search
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    # easier cd navigation
    setopt AUTO_PUSHD
    setopt PUSHD_IGNORE_DUPS

    # tab completion reverse with shift+tab
    bindkey '^[[Z' reverse-menu-complete
    # better tab complete menu
    zstyle ':completion:*' menu select

    # ctrl and alt keys to navigate words
    bindkey '^[[1;5D' backward-word
    bindkey '^[[1;5C' forward-word
    bindkey '^[[1;3D' backward-word
    bindkey '^[[1;3C' forward-word
  '';
}
