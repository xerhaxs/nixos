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
      overrideFolders = false; 
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
          password = "CHAGNEME";
          theme = "black";
          tls = true;
        };

        devices = {
          "NixOS-Desktop" = { id = "GJBFJEC-CUEZR5R-JSXR4TC-SL7YEMY-7XN3KED-TN2BUWQ-XFXRUEY-53GRVQD"; };
          "NixOS-Framework" = { id = "D3M37EV-OQ2WP7T-3PFWSDE-E7DQ74B-LSCQ6DL-75GFL2B-6KBRSAQ-POCUWQH"; };
          "NixOS-Laptop" = { id = "TZIANB3-KBIIN5E-4ADBVLO-6MSC3WJ-U3CTUVW-ERAW4NC-FCKT7KE-KX6ZBQ4"; };
          "GraphenOS" = { id = "NLYJGXH-QP27NVE-4JOX67Q-4XNQHG2-2RGX5LX-I6GL5XN-WU3EVG2-KWM6VQI"; };
        };
      };
    };
  };
}
