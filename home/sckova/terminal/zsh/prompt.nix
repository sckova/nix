# home/sckova/terminal/zsh/prompt.nix
{
  config,
  lib,
  ...
}:
{
  home.file = {
    ".config/zsh/colors.zsh" = {
      force = true;

      text = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: "color_${name}=${value}") (
          lib.filterAttrs (
            n: v: builtins.isString v && builtins.match "^base[0-9A-Fa-f]{2}$" n != null
          ) config.scheme.withHashtag
        )
        ++ [ "color_accent=${config.scheme.withHashtag.${config.colors.accent}}" ]
      );
    };

    ".config/zsh/prompt.zsh" = {
      force = true;

      text = /* zsh */ ''
        autoload -Uz vcs_info
        setopt PROMPT_SUBST
        zstyle ':vcs_info:git:*' formats ' (%b)'
        precmd_functions+=(vcs_info)

        typeset -g prompt_start='%F{$color_base0C}%n%f@%F{$color_accent}%m%f'
        typeset -g prompt_dir='%F{$color_base0B}''${PWD/#$HOME/~}%f'
        typeset -g prompt_git='$vcs_info_msg_0_'
        typeset -g prompt_nix="''${IN_NIX_SHELL:+ <nix-shell>}"

        PROMPT="''${prompt_start} ''${prompt_dir}''${prompt_git}''${prompt_nix}
        > "
      '';
    };
  };
}
