{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.gaming.antimicrox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable antimicrox controller tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.antimicrox.enable {
    home.packages = with pkgs; [
      antimicrox
    ];
  };
}
