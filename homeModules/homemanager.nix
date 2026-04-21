{
  config,
  lib,
  home-manager,
  pkgs,
  specialArgs,
  userName,
  ...
}:

{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = specialArgs // { inherit userName; };

    users.${userName} = import ./default.nix;
  };

  programs.dconf.enable = true;
}
