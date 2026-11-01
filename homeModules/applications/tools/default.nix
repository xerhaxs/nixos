{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    ./backintime.nix
    ./dangerzone.nix
    ./gnomedisk.nix
    ./keepassxc.nix
    ./qalculate.nix
  ];

  options.homeManager = {
    applications.tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable tools modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.tools.enable {
    homeManager.applications.tools = {
      backintime.enable = lib.mkDefault false;
      dangerzone.enable = lib.mkDefault (
        osConfig.nixos.desktop.enable && osConfig.nixos.virtualisation.podman.enable
      );
      gnomedisk.enable = true;
      keepassxc.enable = true;
      qalculate.enable = true;
    };
  };
}
