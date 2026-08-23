# home/sckova/terminal/vscode.nix
{
  config,
  lib,
  pkgs,
  isLinux,
  osConfig,
  ...
}:
{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        jnoortheen.nix-ide
        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "base16-tinted-themes";
          publisher = "TintedTheming";
          sha256 = "sha256-3MsPfa6pdMT30yAnUMKpTIycNZY5ZRd/dS8eshG5r+A=";
          version = "0.45.0";
        })
      ];

      userSettings = {
        "editor.fontFamily" = config.fonts.mono.name;
        "editor.fontSize" = config.fonts.mono.size + 3;
        "editor.formatOnSave" = true;
        "editor.wordWrap" = "on";
        "git.openRepositoryInParentFolders" = "always";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd"; # or ["executable", "argument1", ...]

        # LSP config can be passed via the ``nix.serverSettings.{lsp}`` as shown below.
        # check https =//github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md for all nixd config
        "nix.serverSettings"."nixd" = {
          "options" =
            let
              host = osConfig.networking.hostName;
              project = "/home/sckova/Projects/nix";
            in
            {

              "nixpkgs"."expr" = "import (builtins.getFlake \"${project}\").inputs.nixpkgs { }";
            }
            // lib.optionalAttrs isLinux {
              "home-manager"."expr" =
                "(builtins.getFlake \"${project}\").nixosConfigurations.${host}.options.home-manager.users.type.getSubOptions";

              "nixos"."expr" = "(builtins.getFlake \"${project}\").nixosConfigurations.${host}.options";
            }
            // lib.optionalAttrs (!isLinux) {
              "home-manager"."expr" =
                "(builtins.getFlake \"${project}\").darwinConfigurations.${host}.options.home-manager.users.type.getSubOptions";

              "nix-darwin"."expr" = "(builtins.getFlake \"${project}\").darwinConfigurations.${host}.options";
            };

          "formatting"."command" = [
            (pkgs.writeShellScript "nix-format-integrated" /* bash */ ''
              set -o pipefail
              ${lib.getExe pkgs.nixfmt} \
              | ${lib.getExe pkgs.pedantix} \
              | ${lib.getExe pkgs.nixfmt}
            '')
          ];
        };

        "workbench.colorTheme" = "base24-${config.colors.scheme}";
      };
    };
  };
}
