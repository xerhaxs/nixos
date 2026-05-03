{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.development.virtualisation = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Virtualisation GUIs.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.virtualisation.enable {
    home.packages = with pkgs; [
      spice-gtk
      virt-viewer
    ];

    dconf.settings = {
      "org/virt-manager/virt-manager" = {
        xmleditor-enabled = true;
      };

      "org/virt-manager/virt-manager/confirm" = {
        delete-storage = true;
        forcepoweroff = false;
        poweroff = false;
        removedev = true;
        unapplied-dev = true;
      };

      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };

      "org/virt-manager/virt-manager/console" = {
        resize-guest = 1;
        scaling = 2;
      };

      "org/virt-manager/virt-manager/details" = {
        show-toolbar = true;
      };

      "org/virt-manager/virt-manager/new-vm" = {
        graphics-type = "system";
      };

      "org/virt-manager/virt-manager/stats" = {
        enable-disk-poll = true;
        enable-memory-poll = true;
        enable-net-poll = true;
      };

      "org/virt-manager/virt-manager/vmlist-fields" = {
        disk-usage = true;
        host-cpu-usage = true;
        memory-usage = true;
        network-traffic = true;
      };
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/dconf"
      ];
    };
  };
}
