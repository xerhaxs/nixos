{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.office.kile = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kile";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.kile.enable {
    home.packages = with pkgs; [
      kile
      lmodern
      texliveFull
    ];

    #programs.texlive = {
    #  enable = true;
    #};
  };
}
