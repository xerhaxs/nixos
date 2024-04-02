{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    userEnvironment.autostart.protonmail-bridge = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable protonmail-bridge autostart.";
      };
    };
  };

  config = mkIf config.nixos.userEnvironment.autostart.protonmail-bridge.enable {
    systemd.user.services.${nixos.system.user.defaultuser.name} = {
      script = ''
        protonmail-bridge -n
      '';
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };
}
