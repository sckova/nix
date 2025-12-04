{
  config,
  pkgs,
  lib,
  ...
}:

let
  capitalize =
    str:
    (lib.toUpper (builtins.substring 0 1 str)) + (builtins.substring 1 (builtins.stringLength str) str);
in
{
  # home.sessionVariables = {
  #   EDITOR = "code";
  # };

  catppuccin.vscode.profiles.default = {
    enable = true;
    settings = {
      workbenchMode = "minimal";
    };
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      enableExtensionUpdateCheck = true;
      enableMcpIntegration = true;
      enableUpdateCheck = true;
      # https://search.nixos.org/packages?query=vscode-extensions
      extensions = with pkgs.vscode-extensions; [
        yzhang.markdown-all-in-one
        jnoortheen.nix-ide
        esbenp.prettier-vscode
      ];
      userSettings = {
        "window.menuBarVisibility" = "compact";
        "workbench.navigationControl.enabled" = false;
        "window.commandCenter" = false;
        "workbench.layoutControl.enabled" = false;
        "window.titleBarStyle" = "native";
        "editor.minimap.enabled" = false;
        "editor.semanticHighlighting.enabled" = true;

        # Disable AI "features"
        ## Chat features
        "chat.agent.enabled" = false;
        "chat.commandCenter.enabled" = false;
        "inlineChat.accessibleDiffView" = "off";
        "terminal.integrated.initialHint" = false;
      };
    };
  };
}
