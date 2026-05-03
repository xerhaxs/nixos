{
  config,
  lib,
  osConfig,
  pkgs,
  userName,
  ...
}:

{
  imports = [
    ../../hosts/${osConfig.networking.hostName}/home/default.nix
  ];

  options.homeManager = {
    home.home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable home settings.";
      };
    };
  };

  config = lib.mkIf config.homeManager.home.home.enable {
    home = {
      username = "${userName}";
      homeDirectory = "/home/${userName}";
      stateVersion = "25.11";
    };

    programs.home-manager.enable = true;

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
      ];
    };
  };
}
