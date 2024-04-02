{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    userEnvironment.autostart = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable autostart modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.userEnvironment.autostart.enable {
    imports = [
      ./protonmail-bridge.nix
      ./steam.nix
    ];
  };
}
