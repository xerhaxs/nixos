{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.communication.discord = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Discord.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.discord.enable {
    programs.discord = {
      enable = true;
      package = pkgs.legcord;
      settings = {
        SKIP_HOST_UPDATE = true;
        #DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
      };
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/legcord"
      ];
    };
  };
}
