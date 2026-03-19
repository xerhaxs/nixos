{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.gaming.gameconqueror = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable scanmem / gameconqueror / cheat engine.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.gameconqueror.enable {
    home.packages = with pkgs; [
      scanmem
    ];
  };
}
