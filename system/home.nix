{ config, lib, pkgs, home-manager, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  #home-manager.extraSpecialArgs = specialArgs;
  home-manager.users.${config.defaultuser.name} = {
    imports = [ 
      ./hosts/NixOS-Desktop/home-desktop
      plasma-manager.homeManagerModules.plasma-manager
      flatpak.homeManagerModules.default  
    ];
  };
}