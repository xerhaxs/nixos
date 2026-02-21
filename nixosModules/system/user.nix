{
  config,
  lib,
  pkgs,
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
      defaultuser = {
        name = lib.mkOption {
          type = lib.types.str;
          example = "USER1";
          description = "Set the default user name.";
        };
        pass = lib.mkOption {
          type = lib.types.str;
          example = "$y$j9T$0UcoJ1R/ZXIbBZ5E0HtJT/$I7Q8aZQe/J06G1WZiLlEh0rc7HDOrltYUuDZrZSd4r0";
          description = "Set the pass for the default user as a hash. Create a hash of a password with `mkpasswd`.";
        };
        passfile = lib.mkOption {
          type = lib.types.str;
          #example = "config.sops.secrets."userpassfile".path";
          description = "Set the pass file via sops.";
        };
        shell = lib.mkOption {
          type = lib.types.package;
          default = pkgs.bash;
          example = pkgs.zsh;
          description = "Set the default shell.";
        };
        settings = lib.mkOption {
          default = { };
          description = "The default settings per user.";
        };
      };
    };
  };

  config = lib.mkIf config.nixos.system.user.enable {
    users.users."${config.nixos.system.user.defaultuser.name}" = {
      name = "${config.nixos.system.user.defaultuser.name}";
      isNormalUser = true;
      group = "users";
      createHome = true;
      home = "/home/${config.nixos.system.user.defaultuser.name}";
      description = "${config.nixos.system.user.defaultuser.name}";
      extraGroups = [
        "wheel"
      ];
      initialHashedPassword = "${config.nixos.system.user.defaultuser.pass}";
      #hashedPasswordFile = "${config.nixos.system.user.defaultuser.passfile}";
      shell = config.nixos.system.user.defaultuser.shell;
    };
    users.mutableUsers = false;
  };
}
