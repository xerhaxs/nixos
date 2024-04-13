{ config, inputs, lib, osConfig, outputs, pkgs, ... }:

{
  options.homeManager = {
    home.home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable home settings.";
      };
    };
  };

  config = lib.mkIf config.homeManager.home.home.enable {
    home = {
      username = "${osConfig.system.user.defaultuser.name}";
      homeDirectory = "/home/" + osConfig.system.user.defaultuser.name;
      stateVersion = "24.05";
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit inputs;
        outputs = inputs.self.outputs;
      };

      users.${config.system.user.defaultuser.name} = { ... }: {
        imports = [
          (import config.system.user.defaultuser.settings)
          outputs.homeManagerModules.default;
          ../default.nix
        ];
      };
    };

    programs.home-manager.enable = true;
  };
}