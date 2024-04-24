{ config, lib, pkgs, ... }:

{
  options.nixos = {
    theme.theme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable themeset.";
      };

      colorscheme = {
        type = lib.types.enum [
          "catppuccin"
          "dracula"
        ];
        default = "catppuccin";
      };
    };
  };
}
