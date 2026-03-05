{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.kdeconnect = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kdeconnect.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.kdeconnect.enable {
    programs.kdeconnect.enable = true;
  };
}
