{
  programs.pedantix = {
    enable = true;

    settings = {
      attrs = {
        blank-lines = 1; # number of blank lines between bindings
        flatten = true; # flatten single subvalues into their parent
        merge = true; # merge into nested sets
      };

      format-after-sort = false;
      format-before-sort = false;
      formatter = "off"; # use nixfmt via nixd

      lets = {
        sort = true; # reorder things
      };

      preset = "nixos-module";
    };
  };
}
