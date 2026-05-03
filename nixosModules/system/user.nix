{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  options.nixos = {
    system.user = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Setup the system user.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.user.enable {
    users.users.${userName} = {
      name = "${userName}";
      isNormalUser = true;
      group = "users";
      createHome = true;
      home = "/home/${userName}";
      description = "${userName}";
      extraGroups = [
        "wheel"
      ];
      shell = pkgs.bash;
    };
    users.mutableUsers = false;

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/db/sudo"
      ];
    };
  };
}
