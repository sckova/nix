# home/sckova/terminal/zsh/settings.nix
# comments taken from:
# https://nix-community.github.io/home-manager/options/home-manager/programs/zsh.html
{
  config,
  ...
}:
{
  programs.zsh = {
    # Automatically enter into a directory if typed directly into shell
    autocd = true;

    autosuggestion = {
      # Enable zsh autosuggestions
      enable = true;
      # Custom styles for autosuggestion highlighting. See zshzle(1) for syntax
      highlight = null;

      strategy = [
        # Chooses the most recent match from history
        "history"
        # Chooses a suggestion based on what tab-completion would suggest
        # (requires zpty module)
        "completion"
      ];
    };

    # The default base keymap to use.
    # Type: null or one of “emacs”, “vicmd”, “viins”
    defaultKeymap = "emacs";
    # Directory where the zsh configuration and more should be located,
    # relative to the users home directory
    dotDir = config.xdg.configHome + "/zsh";
    # Enable zsh completion
    enableCompletion = true;

    # Options related to zsh-fast-syntax-highlighting
    fastSyntaxHighlighting = {
      # Whether to enable zsh fast syntax highlighting
      enable = true;
      # Custom values to add to FAST_HIGHLIGHT, like custom chroma configuration
      # see upstream's docs and its built-in chromas:
      # https://github.com/zdharma-continuum/fast-syntax-highlighting/blob/master/CHROMA_GUIDE.adoc
      # https://github.com/zdharma-continuum/fast-syntax-highlighting/tree/master/%E2%86%92chroma
      settings = { };
    };

    # Content to be added to .zshrc
    initContent = /* zsh */ "source ~/.config/zsh/prompt.zsh";
  };
}
