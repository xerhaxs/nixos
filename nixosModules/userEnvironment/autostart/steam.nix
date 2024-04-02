{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    userEnvironment.autostart.steam = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable steam autostart.";
      };
    };
  };

  config = mkIf config.nixos.userEnvironment.autostart.steam.enable {
    systemd.user.services.${config.nixos.system.user.defaultuser.name} = {
      script = ''
        flatpak run com.valvesoftware.Steam
      '';
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };
}
