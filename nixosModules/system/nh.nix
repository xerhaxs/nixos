{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  options.nixos = {
    system.nh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable nh.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.nh.enable {
    programs.nh = {
      enable = true;
      flake = "${
        config.home-manager.users.${userName}.xdg.userDirs.documents
      }/nixos";
      clean = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
