{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./vim.nix
  ];

  options.nixos = {
    base.texteditor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable texteditor modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.texteditor.enable {
    nixos.base.texteditor = {
      vim.enable = true;
    };
  };
}
