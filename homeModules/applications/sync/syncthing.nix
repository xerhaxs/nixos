{ config, lib, pkgs, ... }:

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
      tray.enable = false;
      overrideDevices = true;
      overrideFolders = true;
      cert = "pathtocert";
      key = "pathtokey";
      guiAddress = "127.0.0.1:8384";
      extraOptions = [
        "--gui-theme=black"
      ];

      settings = {
        options = {
          #limitBandwidthInLan
          localAnnounceEnabled = false;
          relaysEnabled = false;
          urAccepted = -1;
        };
        devices = {
          NixOS-Desktop = {
            autoAcceptFolders = false;
            name = "‹name›";
            id = "MFZWI3D-BONSGYC-YLTMRWG-C43ENR5-QXGZDMM-FZWI3DP-BONSGYY-LTMRWAD";

          };

          folders = {
            "Dokumente" = {
              enable = true;
              label = "‹name›";
              path = "/home/jf/Dokumente";
              type = "sendreceive"; # "sendreceive", "sendonly", "receiveonly", "receiveencrypted"
              #versioning.type = "staggered"; # "external", "simple", "staggered", "trashcan"
              copyOwnershipFromParent = false;
              id = "FOLDERID";
              devices = [ "NixOS-Framework" "NixOS-Desktop" ];
            };
          };
        };
      };
    };
  };
}
