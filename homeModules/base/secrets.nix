{
  config,
  lib,
  osConfig,
  pkgs,
  impermanence,
  ...
}:

{
  options.homeManager = {
    base.secrets = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable secrets";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.secrets.enable {
    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/sops"
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".cert";
          mode = "0700";
        }
        {
          directory = ".pki";
          mode = "0700";
        }
      ];
    };
  };
}
