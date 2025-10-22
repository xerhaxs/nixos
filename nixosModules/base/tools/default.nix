{ config, lib, pkgs, ... }:

{
  imports = [
    ./android.nix
    ./common.nix
    ./git.nix
    ./htop.nix
    ./java.nix
    ./keepassxc.nix
    ./usbtop.nix
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
      android.enable = true;
      common.enable = true;
      git.enable = true;
      htop.enable = true;
      java.enable = true;
      keepassxc.enable = true;
      usbtop.enable = true;
      #wireguard-client.enable = true;
    };
  };
}