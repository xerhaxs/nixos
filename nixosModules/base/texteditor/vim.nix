{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.texteditor.vim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Vim.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.texteditor.vim.enable {
    programs.vim.enable = true;
    programs.vim.defaultEditor = true;
  };
}