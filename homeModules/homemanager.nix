{ config, lib, home-manager, pkgs, specialArgs, ... }:

{
  imports = [
    home-manager.nixosModules.home-manager
  ];
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = specialArgs;

    users.${config.nixos.system.user.defaultuser.name} = import ./default.nix;
  };

  programs.dconf.enable = true;
}