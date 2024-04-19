{ config, inputs, lib, osConfig, home-manager, outputs, pkgs, ... }:

{
  home-manager.nixosModules.home-manager 
  {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit inputs;
        outputs = inputs.self.outputs;
      };

      users.${osConfig.system.user.defaultuser.name} = { ... }: {
        imports = [
          (import config.system.user.defaultuser.settings)
          outputs.homeManagerModules.default
          ../homeModules/default.nix
        ];
      };
    };
  }
}
