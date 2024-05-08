{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.syncthing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Syncthing.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.syncthing.enable {
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    services.syncthing = {
      enable = true;
      systemService = true;
      user = "${config.nixos.system.user.defaultuser.name}";
      group = "users";
      dataDir = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}";
      configDir = config.services.syncthing.dataDir + "/.config/syncthing";
      overrideDevices = false;
      overrideFolders = true; 
      openDefaultPorts = true;

      settings = {
        options = {
          urAccepted = -1;
          globalAnnounceEnabled = true;
          localAnnounceEnabled = true;
          relaysEnabled = true;
          startBrowser = false;
        };

        gui = {
          user = "${config.nixos.system.user.defaultuser.name}";
          password = "CHANGEME";
          theme = lib.strings.toLower "black";
          tls = true;
        };
      };
    };
  };
}
