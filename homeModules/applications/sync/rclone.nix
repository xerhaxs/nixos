{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.sync.rclone = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable rclone sync.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.rclone.enable {
    home.packages = with pkgs; [
      rclone-ui
    ];
  };
}
