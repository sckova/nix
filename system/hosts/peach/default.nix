# system/hosts/peach/default.nix
{
  services.logind.settings.Login = {
    HandleLidSwitch = "lock";
    HandlePowerKey = "lock";
    HandleSuspendKey = "ignore";
  };
}
