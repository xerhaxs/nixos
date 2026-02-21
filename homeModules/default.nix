{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    ./applications
    ./base
    ./desktop
    ./home
    ./theme
    ./userEnvironment
  ];

  options.homeManager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Enable homeManager modules bundle.";
    };
  };

  config = lib.mkIf config.homeManager.enable {
    homeManager = {
      base.enable = lib.mkIf osConfig.nixos.base.enable true;
      desktop.enable = lib.mkIf osConfig.nixos.desktop.enable true;
      home.enable = true;
      theme.enable = lib.mkIf osConfig.nixos.theme.enable true;
      userEnvironment.enable = lib.mkIf osConfig.nixos.userEnvironment.enable true;
    };
  };
}
