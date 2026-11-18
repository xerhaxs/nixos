{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.sync.resticBrowser.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enable Restic Browser with restic and rclone (browse and restore the backup of NixOS-Server1 on Proton Drive).";
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.resticBrowser.enable {
    # Restic Browser calls restic and rclone from PATH.
    home.packages = with pkgs; [
      rclone
      restic
      restic-browser
    ];

    # rclone keeps the Proton session (renewed tokens) in its config, restic caches the index.
    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".cache/restic"
        ".config/rclone"
      ];
    };
  };
}
