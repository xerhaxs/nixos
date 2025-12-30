{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.bootloader = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bootloader.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.bootloader.enable {
  
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.efi.efiSysMountPoint = "/boot/";

    boot.loader.limine.extraEntries = ''
      title: Reboot
      linuxPath: /bin/systemctl
      initrdPath:
      options: reboot

      title: Poweroff
      linuxPath: /bin/systemctl
      initrdPath:
      options: poweroff
    '';

    boot.loader.limine = {
      enable = true;
      efiSupport = true;
      enableEditor = false;
      maxGenerations = 32;
      validateChecksums = true;
      panicOnChecksumMismatch = true;
    };
  };
}
