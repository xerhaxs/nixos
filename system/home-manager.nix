{ config, lib, pkgs, flatpak ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.extraSpecialArgs = specialArgs;
  home-manager.users.${config.defaultuser.name} = { lib, pkgs, nixosConfig, ... }: {
    imports = [ 
      ./hosts/NixOS-Desktop/home-desktop
      flatpak.homeManagerModules.default  
    ];
  };
}