{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./antimicrox.nix
    ./gameconqueror.nix
    ./heroic.nix
    ./lutris.nix
    ./mangohud.nix
    ./prismlauncher.nix
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
      antimicrox.enable = lib.mkDefault false;
      gameconqueror.enable = true;
      heroic.enable = true;
      lutris.enable = true;
      mangohud.enable = true;
      prismlauncher.enable = true;
    };
  };
}
