{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.xserver = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable xserver settings.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.xserver.enable {
    services.xserver = {
      enable = true;
    };

    services.xserver.excludePackages = with pkgs; [
      xterm
    ];
  };
}
