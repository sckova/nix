# home/sckova/terminal/zsh/syntax-highlighting.nix
{
  home.file.".config/zsh/fast-syntax-colors.zsh".text = /* zsh */ ''
    # runs before fast-syntax-highlighting sources (order 1000 vs 1200),
    # so declare the array ourselves rather than relying on the plugin
    typeset -gA FAST_HIGHLIGHT_STYLES

    # translated from fish's default theme (share/themes/default.theme)
    FAST_HIGHLIGHT_STYLES[comment]='fg=red'
    FAST_HIGHLIGHT_STYLES[redirection]='fg=cyan,bold'
    FAST_HIGHLIGHT_STYLES[commandseparator]='fg=green'
    FAST_HIGHLIGHT_STYLES[globbing]='fg=14'
    FAST_HIGHLIGHT_STYLES[unknown-token]='fg=9'
    FAST_HIGHLIGHT_STYLES[matherr]='fg=9'
    FAST_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
    FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=cyan,underline'
    FAST_HIGHLIGHT_STYLES[back-or-dollar-double-quoted-argument]='fg=14'
    FAST_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=14'

    # literal fish parity: fish doesn't color valid commands/keywords
    # remove this block to keep F-Sy-H's green command recognition instead
    FAST_HIGHLIGHT_STYLES[reserved-word]='none'
    FAST_HIGHLIGHT_STYLES[subcommand]='none'
    FAST_HIGHLIGHT_STYLES[command]='none'
    FAST_HIGHLIGHT_STYLES[builtin]='none'
    FAST_HIGHLIGHT_STYLES[function]='none'
    FAST_HIGHLIGHT_STYLES[precommand]='none'
    FAST_HIGHLIGHT_STYLES[hashed-command]='none'
    FAST_HIGHLIGHT_STYLES[alias]='none'
    FAST_HIGHLIGHT_STYLES[suffix-alias]='none'
  '';
}
