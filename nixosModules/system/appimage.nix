{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.appimage = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable appimage.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.appimage.enable {
    environment.systemPackages = with pkgs; [
      appimage-run
    ]
  };
}
