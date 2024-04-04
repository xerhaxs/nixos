{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable tools modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.enable {
    imports = [
      ./common.nix
      ./git.nix
      ./htop.nix
      ./openvpn-client.nix
      ./syncthing.nix
      ./wireguard-client.nix
    ];
  };
}