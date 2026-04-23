{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  options = {
    nixos.virtualisation.podman = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable podman virtualisation.";
      };
    };
  };

  config = lib.mkIf config.nixos.virtualisation.podman.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      enableNvidia = lib.mkIf (
        config.nixos.hardware.nvidiagpu.enable && config.nixos.virtualisation.podman.enable
      ) true;
    };

    virtualisation.oci-containers = {
      backend = "podman";
    };

    users.users.${userName} = {
      extraGroups = [
        "podman"
        "video"
        "render"
      ];
    };

    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
