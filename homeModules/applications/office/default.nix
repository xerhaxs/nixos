{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./financial.nix
    ./gwenview.nix
    ./joplin.nix
    ./office.nix
    ./okular.nix
    ./skanpage.nix
  ];

  options.homeManager = {
    applications.office = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable office modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.enable {
    homeManager.applications.office = {
      financial.enable = true;
      gwenview.enable = true;
      joplin.enable = true;
      office.enable = true;
      okular.enable = true;
      skanpage.enable = true;
    };
  };
}
