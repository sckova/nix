{
  lib,
  pkgs,
  isLinux,
  users,
  ...
}:
let
  hasCkovacs = builtins.elem "ckovacs" users;
  hasSckova = builtins.elem "sckova" users;
  linuxConfig = {
    users = {
      groups.shared = { };
      mutableUsers = false;

      users = {
        ckovacs = lib.mkIf hasCkovacs {
          extraGroups = [
            "wheel"
            "networkmanager"
            "podman"
            "pipewire"
            "shared"
          ];

          isNormalUser = true;
        };

        sckova = lib.mkIf hasSckova {
          extraGroups = [
            "wheel"
            "networkmanager"
            "podman"
            "pipewire"
            "shared"
          ];

          hashedPassword = "$6$amkrG3OSvwlVMziQ$sPkza.Vac/cg66TRETQNmpm9IoUaJA2Zs2NfUU3kBughePWhb6IVYwBhACx.6fA40WehrwiMbCI82nOd5380M/";
          isNormalUser = true;
        };

        shared = {
          description = "Shared account for common files";
          group = "users";
          isSystemUser = true;
        };
      };
    };
  };
  sharedConfig = {
    programs.zsh.enable = true;

    users.users = {
      ckovacs = lib.mkIf hasCkovacs {
        description = "Christopher Kovacs";

        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAsCIIpkdtHVleFyjRFqmvtd/7tgyAOsNCOXS+aI8klqHMO5cekBVkpnlfsdEluCIpfKq50Ikjf/oW4AJt6tWO0GVtlG3UaZS4EjLGzvDxyKHdCnOnqyzF9JGkxxumKM45qro7ve5DtObBYOmkYZgjWKsz51ptw0pUu3Tx/k3sRV6SzKp++gW2d1ZoM33Hhxd6603tjOz6AzwDRv63u8x09pInA4F/R6EPlj+UXMDFABSfEPOZM93kCeCe481YuD2IqVys5cRlBiB/OxedQ6sY5LL1bbZjZCfaiRz21m2YUhSISZlyXr357hHj89wGkxGZMyipeO7nGjHaG0eB0uH7 ckovacs@ibm.com"
        ];

        shell = pkgs.zsh;
      };

      sckova = lib.mkIf hasSckova {
        description = "Sean Kovacs";

        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCn/eXMq04vcXNqGVzlZOw2C2dQYBqzWsoigdFW09XqC2WPaGljbAIayzaD7Q1tIlPGGy10+nipAXAk1CHAnrQ2KSg4v/SwFphF48V3joeQmideC4vo0EIQEQibbMtj3oFezqRcRZINl/1hr4t0myZ3zkoTjh3HCkqJEMGUdArDMEVPA5mwcKSLsyshW9LMG/3C9YKKPU1/lVsoeDkj8AVZA0srhkApuRKF0IVu8KoPd6ldvSWgpQ1iuQ+MEMSeOUJytieBkzeY9zEVePaQ86oIMDUzqq8OTN37RyShiJKPskKyj12rJI2eFtI/viGaj8P6/yvKqMp3F4kAsPAuvMLLAIYCNa+139rDpkkIKB6lVtgq0jnJGRywaYXGIRyExNcVAr8I9wrNnNN2M4whVeYBxfLMzKZ+VvfK39AaGvnzPuFDLqUC87sN4c/1KZQo+TCtlaxcYvqowWylw5JHUt8uwFcO/dUebQxxAv8EdyPZGJ/54y19PsTbu9KyxSc2gIU= sckova"
        ];

        shell = pkgs.zsh; # even though i use fish, it's better to set this at the app level
      };
    };
  };

in
if isLinux then
  lib.mkMerge [
    sharedConfig
    linuxConfig
  ]
else
  sharedConfig
