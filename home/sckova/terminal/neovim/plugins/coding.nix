{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nixfmt
    prettier
    prettierd
    stylua
    black
    clang-tools
  ];

  programs.nixvim.plugins = {
    cmp = {
      enable = true;

      settings = {
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };

        sources = [
          { name = "nvim_lsp"; }
          { name = "buffer"; }
          { name = "path"; }
        ];
      };
    };

    conform-nvim = {
      enable = true;

      settings = {
        default_format_opts.lsp_format = "last";

        format_on_save = {
          run_all_formatters = true;
          timeout_ms = 500;
        };

        formatters = {
          pedantix = {
            command = lib.getExe pkgs.pedantix;
            stdin = true;
          };

          shfmt.append_args = [
            "-i"
            "2"
          ];
        };

        formatters_by_ft = {
          c = [ "clang-format" ];
          cpp = [ "clang-format" ];
          css = [ "prettier" ];
          fish = [ "fish_indent" ];
          html = [ "prettier" ];
          javascript = [ "prettier" ];
          json = [ "prettier" ];
          jsonc = [ "prettier" ];
          lua = [ "stylua" ];
          nix = [ "injected" ];
          python = [ "black" ];
        };
      };
    };

    fzf-lua.enable = true;

    lsp = {
      enable = true;

      servers = {
        bashls.enable = true;

        nil_ls = {
          enable = true;

          settings = {
            formatting.command = [
              (pkgs.writeShellScript "nix-format-integrated" /* bash */ ''
                set -o pipefail
                ${lib.getExe pkgs.nixfmt} \
                | ${lib.getExe pkgs.pedantix} \
                | ${lib.getExe pkgs.nixfmt}
              '')
            ];

            nix = {
              binary = "/run/current-system/sw/bin/nix";

              flake = {
                autoArchive = true;
                autoEvalInputs = true;
                nixpkgsInputName = "nixpkgs";
              };

              maxMemoryMB = 8192;
            };
          };
        };

        qmlls = {
          enable = true;

          cmd = [
            "qmlls"
            "-E"
          ];
        };
      };
    };

    nvim-autopairs.enable = true;
    otter.enable = true;
    render-markdown.enable = true;

    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = false;

      settings.ensure_installed = [
        "nix"
        "css"
        "markdown"
        "markdown_inline"
        "bash"
      ];
    };
  };
}
