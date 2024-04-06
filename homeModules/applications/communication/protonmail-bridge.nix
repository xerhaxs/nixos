{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.communication.protonmail-bridge = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Protonmail bridge.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.protonmail-bridge.enable {
    home.packages = with pkgs; [
      protonmail-bridge
    ];
  };
}
