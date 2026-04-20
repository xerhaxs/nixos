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
      aqbanking
      kmymoney
    ];

    /* xdg.configFile."kilerc".text = ''
      [General Options]
      AutoSaveFile=true
      ExpertMode=true
      Geometry=1912,1519
      LastUsedDirectory=/mount/Data/Datein/Dokumente/Banking/KMyMoney Daten
      LastUsedFile=/mount/Data/Datein/Dokumente/Banking/KMyMoney Daten/KMyMoney Daten.kmy
      LastViewSelected=7
      Show Statusbar=true
      firstTimeRun=false
    ''; */
  };
}
