{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./git.nix
    ./htop.nix
    ./openvpn-client.nix
    ./syncthing.nix
    ./wireguard-client.nix
  ];

  options.nixos = {
    base.tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable tools modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.enable {
    nixos.base.tools = {
      common.enable = true;
      git.enable = true;
      htop.enable = true;
      #openvpn-client.enable = true;
      syncthing.enable = true;
      #wireguard-client.enable = true;
    };
  };
}