{
  config,
  pkgs,
  ...
}:
{
  programs = {
    bat = {
      config = {
        style = "numbers,changes";
        theme = "base16";
      };

      enable = true;
    };

    fzf = {
      enable = true;

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

      defaultOptions = [
        "--height 40%"
        "--border"
      ];

      enableFishIntegration = true;
    };

    gh = {
      enable = true;

      hosts."github.com" = {
        git_protocol = "https";
        user = config.home.username;
        users.${config.home.username} = ""; # dunno, this was how it generated
      };

      settings = {
        accessible_colors = "disabled";
        accessible_prompter = "disabled";

        aliases = {
          co = "pr checkout";
        };

        browser = "${pkgs.firefox}/bin/firefox";
        color_labels = "enabled";
        editor = "${pkgs.neovim}/bin/nvim";
        git_protocol = "https";
        pager = "${pkgs.bat}/bin/bat";
        prefer_editor_prompt = "disabled";
        prompt = "enabled";
        spinner = "enabled";
        version = 1;
      };
    };

    git = {
      enable = true;

      settings = {
        commit.gpgsign = true;
        core.pager = "${pkgs.bat}/bin/bat";
        init.defaultBranch = "main";
        safe.directory = "/home/nix";

        user = {
          email = config.email;
          name = config.name;
        };
      };
    };

    lazygit = {
      enable = true;
      enableFishIntegration = true;
    };

    lazysql.enable = true;
  };

}
