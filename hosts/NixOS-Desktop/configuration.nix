{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  _module.args.userName = "jf";

  nixos.system.sops.file = "clients";
  nixos.system.user.passwordFromSops = true;

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

  nixos.userEnvironment.enable = true;

  nixos.virtualisation.android.enable = true;
  nixos.virtualisation.kvm.enable = true;
  nixos.virtualisation.podman.enable = true;
}
