{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    base.bash = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bash.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.bash.enable {
    programs.bash = {
      completion.enable = true;
      blesh.enable = false;
      vteIntegration = true;
      #shellAliases = { };
      #shellInit = "";
    };

    programs.nix-index.enableBashIntegration = true;

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      files = [
        "/root/.bash_history"
      ];
    };
  };
}
