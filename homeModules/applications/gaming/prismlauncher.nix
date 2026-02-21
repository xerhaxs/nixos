{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.gaming.prismlauncher = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable prismlauncher.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.prismlauncher.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
