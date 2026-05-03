{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    base.persistent = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable persistent.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.persistent.enable {
    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".cache"
        ".local/cache"
        ".local/state"

        #".winboat"
        #".wine"
        #".config/Proton"
        #".config/Proton Mail"
        #".config/steamtinkerlaunch"
        #".local/share/protonmail"
        #".local/share/wasistlos"
        #".local/share/whatsapp-for-linux"
        #karere
      ];
    };
  };
}
