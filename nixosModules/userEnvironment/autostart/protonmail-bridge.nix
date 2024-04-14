{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.autostart.protonmail-bridge = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable protonmail-bridge autostart.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.autostart.protonmail-bridge.enable {
    systemd.user.services.${config.nixos.system.user.defaultuser.name} = {
      script = ''
        protonmail-bridge -n
      '';
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };
}
