{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  options.nixos = {
    userEnvironment.io.camera = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable camera support";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.io.camera.enable {
    programs.gphoto2.enable = true;

    environment.systemPackages = with pkgs; [
      gphoto2
      kdePackages.kamera
    ];

    users.users."${userName}" = {
      extraGroups = [
        "camera"
      ];
    };
  };
}
