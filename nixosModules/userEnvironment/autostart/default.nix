{ config, lib, pkgs, ... }:

{
  imports = [
    ./protonmail-bridge.nix
    ./steam.nix
  ];

  options.nixos = {
    userEnvironment.autostart = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable autostart modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.autostart.enable {
    nixos.userEnvironment.autostart = {
      protonmail-bridge.enable = false;
      steam.enable = false;
    };
  };
}
