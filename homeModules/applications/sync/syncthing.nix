{ config, lib, osConfig, pkgs, ... }:

{
  options.homeManager = {
    applications.sync.syncthing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable syncthing sync.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.syncthing.enable {
    services.syncthing = {
      enable = true;
      passwordFile = SOPSPATHFORGUIPASSWORDFILE;
      key = Path to the key.pem file, which will be copied into Syncthing's
config directory.;
      cert = Path to the cert.pem file, which will be copied into Syncthing's
config directory.;

      overrideDevices = true;
      overrideFolders = true;

      guiAddress = "127.0.0.1:8384";

      tray = {
        enable = false;
      };

      settings = {
        gui = {
          user = "${osConfig.nixos.system.user.defaultuser.name}";
          theme = lib.strings.toLower "black";
          tls = true;
        };

        options = {
          globalAnnounceEnabled = false;
          localAnnounceEnabled = false;
          relaysEnabled = false;
          startBrowser = false;
          urAccepted = "-1";
        };

        devices = {
          NixOS-Convertible = {
            name = "NixOS-Convertible";
            id = "7CFNTQM-IMTJBHJ-3UWRDIU-ZGQJFR6-VCXZ3NB-XUH3KZO-N52ITXR-LAIYUAU"; #(put it in sops)
            autoAcceptFolders = false;
          };
        };

        folders = {
          "Desktop" = {
            enable = true;
            id = "Desktop";
            label = "Desktop";
            path = "${config.xdg.userDirs.desktop}";
            type = "sendreceive"; # "sendreceive", "sendonly", "receiveonly", "receiveencrypted"
            devices [ "NixOS-Convertible" "NixOS-Desktop" "NixOS-Framework" "NixOS-Server1" ]; # "GraphenOS"
            copyOwnershipFromParent = false;
          };
        };
      };
    };
  };
}
