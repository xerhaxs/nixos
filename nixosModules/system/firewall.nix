{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    system.firewall = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable network firewall.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.firewall.enable {
    networking.firewall = {
      enable = true;
      allowPing = true;
    };
  };
}
