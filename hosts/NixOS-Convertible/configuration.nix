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

  system.stateVersion = "25.11";

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

  nixos.hardware = {
    intelcpu.enable = true;
    intelgpu.enable = true;
  };

  hardware.sensor.iio.enable = true;

  nixos.system.secureboot.enable = true;
  nixos.disko.disko-luks-btrfs-tmpfs.tpm2 = true;

  nixos.userEnvironment.enable = true;
  nixos.userEnvironment.networkshares.webdav.enable = true;

  nixos.virtualisation.android.enable = true;
  nixos.virtualisation.kvm.enable = true;
  nixos.virtualisation.podman.enable = true;
}
