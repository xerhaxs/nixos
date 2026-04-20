{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./bash.nix
    ./common.nix
    ./console.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
  ];

  options.nixos = {
    base = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable base modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.enable {
    nixos.base = {
      bash.enable = true;
      common.enable = true;
      console.enable = true;
      git.enable = true;
      tmux.enable = true;
      vim.enable = true;
    };
  };
}
