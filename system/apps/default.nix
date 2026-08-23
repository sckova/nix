# system/apps/default.nix
{ pkgs, ... }: {
  imports = [
    # ./obs.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    firefoxpwa
    file-roller
  ];

  programs.nh.enable = true;
}
