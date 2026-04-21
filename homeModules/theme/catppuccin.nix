{
  catppuccin,
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    catppuccin.homeModules.catppuccin
  ];

  options.homeManager = {
    theme.catppuccin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable catppuccin theme.";
      };
    };
  };

  config = lib.mkIf osConfig.nixos.theme.catppuccin.enable {
    catppuccin = {
      enable = true;
      enableReleaseCheck = true;
      accent = "mauve";
      flavor = "mocha";
      #sources = "";
    };
  };
}
