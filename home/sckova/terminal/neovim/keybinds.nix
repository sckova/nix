# home/sckova/terminal/neovim/keybinds.nix
{
  programs.nixvim.keymaps = [
    # --- Normal mode mappings ---
    {
      options = {
        noremap = true;
        silent = true;
      };

      action = "\"+y";
      key = "<C-c>";
      mode = "n";
    }
    {
      options = {
        noremap = true;
        silent = true;
      };

      action = "\"+p";
      key = "<C-p>";
      mode = "n";
    }
    {
      options = {
        desc = "Format buffer";
        noremap = true;
        silent = true;
      };

      action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<CR>";
      key = "<leader>fa";
      mode = "n";
    }

    # --- Visual mode mappings ---
    {
      options = {
        noremap = true;
        silent = true;
      };

      action = "\"+y";
      key = "<C-c>";
      mode = "v";
    }
    {
      options = {
        noremap = true;
        silent = true;
      };

      action = "\"+p";
      key = "<C-p>";
      mode = "v";
    }

    # --- Folding mappings ---
    {
      options = {
        desc = "toggle fold under cursor";
        noremap = true;
        silent = true;
      };

      action = "za";
      key = "<leader><Space>";
      mode = "n";
    }

    # --- Toggle Markdown for current file ---
    {
      options = {
        desc = "toggle Markdown rendering";
        noremap = true;
        silent = true;
      };

      action = "<cmd>RenderMarkdown toggle<CR>";
      key = "<C-m>";

      mode = [
        "n"
        "v"
      ];
    }
    # --- Run FzfLua ---
    {
      options = {
        desc = "run fzf to find files";
        noremap = true;
        silent = true;
      };

      action = "<cmd>FzfLua files<CR>";
      key = "<leader>ff";
      mode = "n";
    }
  ];
}
