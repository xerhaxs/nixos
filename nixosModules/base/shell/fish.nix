{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.shell.fish = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bash.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.shell.fish.enable {
    programs.fish = {
      enable = true;
    };

    programs.nix-index.enableFishIntegration = true;
  };
}