{
  config,
  lib,
  pkgs,
  ...
}:

{
  _module.args.userName = "jf";

  nixos.desktop = {
    enable = true;
    desktopEnvironment = {
      plasma6.enable = true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = true;
    };
    windowManager = {
      hyprland.enable = false; # disabled 2026-11-03, see TODO phase 18
    };
  };

  nixos.theme.catppuccin = {
    accent = "Mauve";
    flavor = "Mocha";
  };

  nixos.system.sops.file = "nixos-portable";
  nixos.system.user.passwordFromSops = true;

  nixos.userEnvironment.enable = true;

  nixos.virtualisation = {
    android.enable = true;
    kvm.enable = true;
    podman.enable = true;
    waydroid.enable = true;
  };
}
