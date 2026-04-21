{
  config,
  lib,
  pkgs,
  catppuccin,
  ...
}:

{
  options.nixos = {
    theme.catppuccin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable catppuccin theme.";
      };

      flavor = lib.mkOption {
        type = lib.types.enum [
          "Latte"
          "Frappe"
          "Macchiato"
          "Mocha"
        ];
        default = "Mocha";
      };

      size = lib.mkOption {
        type = lib.types.enum [
          "Standard"
          "Compact"
        ];
        default = "Standard";
      };

      tweaks = lib.mkOption {
        type = lib.types.enum [
          "Black"
          "Rimless"
          "Normal"
          "Float"
        ];
        default = "Normal";
      };

      winDecStyles = lib.mkOption {
        type = lib.types.enum [
          "Modern"
          "Classic"
        ];
        default = "Modern";
      };

      accent = lib.mkOption {
        type = lib.types.enum [
          "Blue"
          "Dark"
          "Flamingo"
          "Green"
          "Lavender"
          "Light"
          "Maroon"
          "Mauve"
          "Peach"
          "Pink"
          "Red"
          "Rosewater"
          "Sapphire"
          "Sky"
          "Teal"
          "Yellow"
        ];
        default = "Mauve";
      };

      prefer = lib.mkOption {
        type = lib.types.enum [
          "Dark"
          "Light"
        ];
        default = "Dark";
      };
    };
  };

  config = lib.mkIf config.nixos.theme.catppuccin.enable {
    # test https://nix.catppuccin.com/options/main/nixos/catppuccin/
    catppuccin = {
      enable = true;
      enableReleaseCheck = true;
      accent = "mauve";
      flavor = "mocha";
      #sources = "";
    };
  };
}
