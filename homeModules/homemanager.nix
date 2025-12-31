{ config, lib, home-manager, pkgs, specialArgs, ... }:

{
  imports = [
    home-manager.nixosModules.home-manager
    #impermanence.homeManagerModules.impermanence
  ];
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = specialArgs;

    users.${config.nixos.system.user.defaultuser.name} = import ./default.nix;
  };
}