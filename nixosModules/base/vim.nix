{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    base.vim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Vim.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.vim.enable {
    programs.vim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
