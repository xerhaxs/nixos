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

    home.file.".local/share/PrismLauncher".source = config.lib.file.mkOutOfStoreSymlink (
      config.xdg.userDirs.extraConfig.GAMES + "/Prism/PrismLauncher"
    );
  };
}
