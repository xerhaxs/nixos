{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.autostart.steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable steam autostart.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.autostart.steam.enable {
    systemd.user.services.${config.nixos.system.user.defaultuser.name} = {
      script = ''
        flatpak run com.valvesoftware.Steam
      '';
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };
}
