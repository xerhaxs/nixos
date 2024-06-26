{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.shell.bash = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bash.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.shell.bash.enable {
    programs.bash = {
      completion.enable = true;
      blesh.enable = false;
      vteIntegration = true;
      #shellAliases = { };
      #shellInit = "";
    };

    programs.nix-index.enableBashIntegration = true;
  };
}