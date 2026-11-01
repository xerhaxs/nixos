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

      passwordFromSops = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Read the password hash of the system user from sops (user/<hostname>/<username>).";
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
      initialHashedPassword = lib.mkIf (!config.nixos.system.user.passwordFromSops) (
        config.nixos.site.initialHashedPasswords.${lib.toLower config.networking.hostName} or null
      );
      hashedPasswordFile =
        lib.mkIf config.nixos.system.user.passwordFromSops
          config.sops.secrets."user/${lib.toLower config.networking.hostName}/${userName}".path;
    };
    users.mutableUsers = false;

    sops.secrets."user/${lib.toLower config.networking.hostName}/${userName}" =
      lib.mkIf config.nixos.system.user.passwordFromSops
        {
          neededForUsers = true;
        };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/db/sudo"
      ];
    };
  };
}
