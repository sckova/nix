{ config, ... }:

{
  programs.ghostwriter = {
    enable = true;
    font = {
      family = config.userOptions.fontSans.name;
      pointSize = config.userOptions.fontSans.size;
    };
  };

  programs.kate = {
    enable = true;
    editor = {
      font = {
        family = config.userOptions.fontMono.name;
        pointSize = config.userOptions.fontMono.size;
      };
    };
  };
}
