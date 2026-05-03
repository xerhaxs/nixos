{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./gameconqueror.nix
    ./heroic.nix
    ./lutris.nix
    ./mangohud.nix
    ./prismlauncher.nix
    ./steam.nix
  ];

  options.homeManager = {
    applications.gaming = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable gaming modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.enable {
    homeManager.applications.gaming = {
      gameconqueror.enable = true;
      heroic.enable = true;
      lutris.enable = lib.mkDefault false;
      mangohud.enable = true;
      prismlauncher.enable = true;
      steam.enable = true;
    };
  };
}
