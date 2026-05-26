{
  config,
  pkgs,
  ...
}:
{
  programs = {
    gh = {
      enable = true;
      hosts."github.com" = {
        git_protocol = "https";
        users.${config.home.username} = ""; # dunno, this was how it generated
        user = config.home.username;
      };
      settings = {
        version = 1;
        git_protocol = "https";
        editor = "${pkgs.neovim}/bin/nvim";
        prompt = "enabled";
        prefer_editor_prompt = "disabled";
        pager = "${pkgs.bat}/bin/bat";
        aliases = {
          co = "pr checkout";
        };
        browser = "${pkgs.firefox}/bin/firefox";
        color_labels = "enabled";
        accessible_colors = "disabled";
        accessible_prompter = "disabled";
        spinner = "enabled";
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = config.name;
          email = config.email;
        };
        core.pager = "${pkgs.bat}/bin/bat";
        commit.gpgsign = true;
        init.defaultBranch = "main";
        safe.directory = "/home/nix";
      };
    };
    bat = {
      enable = true;
      config = {
        style = "numbers,changes";
        theme = "base16";
      };
    };
    lazygit = {
      enable = true;
      enableFishIntegration = true;
    };
    lazysql.enable = true;
    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--border"
      ];
      colors = with config.scheme.withHashtag; {
        bg = base00;
        "bg+" = base01;
        border = base03;
        fg = base05;
        "fg+" = base05;
        header = base08;
        hl = base08;
        "hl+" = base08;
        info = config.scheme.withHashtag.${config.colors.accent};
        label = base05;
        marker = base07;
        pointer = base06;
        prompt = config.scheme.withHashtag.${config.colors.accent};
        "selected-bg" = base02;
        spinner = base06;
      };
    };
  };

}
