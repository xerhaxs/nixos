{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./fail2ban.nix
    ./mullvad-server.nix
    ./nginx.nix
    ./pihole.nix
    ./unbound.nix
  ];

  options.nixos = {
    server.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable network modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.enable {
    nixos.server.network = {
      fail2ban.enable = lib.mkDefault false;
      mullvad-server.enable = true;
      nginx.enable = true;
      pihole.enable = true;
      unbound.enable = true;
    };
  };
}
