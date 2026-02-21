{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.development.nixd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable nixd tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.nixd.enable {
    home.packages = with pkgs; [
      nixfmt
      nixd
    ];
  };
}
