{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.pulsar = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Pulsar IDE.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.pulsar.enable {
    home.packages = with pkgs; [
      pulsar
    ];
  };
}
