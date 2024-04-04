{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.texteditor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable texteditor modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.texteditor.enable {
    imports = [
      ./vim.nix
    ];
  };
}