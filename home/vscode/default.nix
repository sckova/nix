{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableExtensionUpdateCheck = true;
      enableMcpIntegration = true;
      enableUpdateCheck = true;
      extensions = with pkgs.vscode-extensions; [
      ];
      userSettings = {
        "workbench.colorTheme" = "Catppuccin Alt Mocha";
        "window.menuBarVisibility" = "compact";
        "workbench.navigationControl.enabled" = false;
        "window.commandCenter" = false;
        "chat.commandCenter.enabled" = false;
        "workbench.layoutControl.enabled" = false;
        "window.titleBarStyle" = "native";
        "editor.minimap.enabled" = false;
        "chat.mcp.gallery.enabled" = true;

        "editor.semanticHighlighting.enabled" = true;
        "workbench.iconTheme" = "catppuccin-mocha";
      };
    };
  };
}
