{ config, lib, pkgs, ... }:

{
  options.nixos = {
    virtualisation.android = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable android.";
      };
    };
  };

  config = lib.mkIf config.nixos.virtualisation.android.enable {
    environment.systemPackages = with pkgs; [
      android-tools
    ];
  };
}