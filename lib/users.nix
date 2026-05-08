{
  config,
  lib,
  users,
  ...
}:
{
  users.users.sckova = lib.mkIf (builtins.elem "sckova" users) {
    isNormalUser = true;
    description = "Sean Kovacs";
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman"
      "pipewire"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCn/eXMq04vcXNqGVzlZOw2C2dQYBqzWsoigdFW09XqC2WPaGljbAIayzaD7Q1tIlPGGy10+nipAXAk1CHAnrQ2KSg4v/SwFphF48V3joeQmideC4vo0EIQEQibbMtj3oFezqRcRZINl/1hr4t0myZ3zkoTjh3HCkqJEMGUdArDMEVPA5mwcKSLsyshW9LMG/3C9YKKPU1/lVsoeDkj8AVZA0srhkApuRKF0IVu8KoPd6ldvSWgpQ1iuQ+MEMSeOUJytieBkzeY9zEVePaQ86oIMDUzqq8OTN37RyShiJKPskKyj12rJI2eFtI/viGaj8P6/yvKqMp3F4kAsPAuvMLLAIYCNa+139rDpkkIKB6lVtgq0jnJGRywaYXGIRyExNcVAr8I9wrNnNN2M4whVeYBxfLMzKZ+VvfK39AaGvnzPuFDLqUC87sN4c/1KZQo+TCtlaxcYvqowWylw5JHUt8uwFcO/dUebQxxAv8EdyPZGJ/54y19PsTbu9KyxSc2gIU= sckova"
    ];
    hashedPasswordFile = config.sops.secrets.sckova_password.path;
  };

  sops.secrets.sckova_password.neededForUsers = true;

  users.users.ckovacs = lib.mkIf (builtins.elem "ckovacs" users) {
    isNormalUser = true;
    description = "Christopher Kovacs";
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman"
      "pipewire"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAsCIIpkdtHVleFyjRFqmvtd/7tgyAOsNCOXS+aI8klqHMO5cekBVkpnlfsdEluCIpfKq50Ikjf/oW4AJt6tWO0GVtlG3UaZS4EjLGzvDxyKHdCnOnqyzF9JGkxxumKM45qro7ve5DtObBYOmkYZgjWKsz51ptw0pUu3Tx/k3sRV6SzKp++gW2d1ZoM33Hhxd6603tjOz6AzwDRv63u8x09pInA4F/R6EPlj+UXMDFABSfEPOZM93kCeCe481YuD2IqVys5cRlBiB/OxedQ6sY5LL1bbZjZCfaiRz21m2YUhSISZlyXr357hHj89wGkxGZMyipeO7nGjHaG0eB0uH7 ckovacs@ibm.com"
    ];
  };
}
