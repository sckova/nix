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
            source ~/.config/zsh/colors.zsh

            autoload -Uz vcs_info
            setopt PROMPT_SUBST
            zstyle ':vcs_info:git:*' formats ' (%b)'
            precmd_functions+=(vcs_info)

            PROMPT='%F{$color_base0C}%n%f@%F{$color_accent}%m%f %F{$color_base0B}''${PWD/#$HOME/~}%f''${vcs_info_msg_0_}''${IN_NIX_SHELL:+ <nix-shell>}
        > '
      '';
    };
  };
}
