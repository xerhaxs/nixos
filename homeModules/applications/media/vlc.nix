{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.media.vlc = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable vlc.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.vlc.enable {
    home.packages = with pkgs; [
      vlc
    ];

    home.activation.vlcConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      CONFIG="$HOME/.config/vlc/vlcrc"
      if [ -f "$CONFIG" ]; then
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" core metadata-network-access 0
      fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/vlc"
      ];
    };
  };
}
