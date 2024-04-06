{ config, lib, pkgs, ... }:

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
    programs.discocss = {
      enable = true;
      discordAlias = true;
      discordPackage = pkgs.webcord;
    };
  };
}
