{ config, lib, pkgs, ... }:

let
  homeDir = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}";
  configDir = "${homeDir}/.config/kmymoney";
  configFile = "${configDir}/kmymoneyrc";
  configContent = ''
    [General Options]
    AutoSaveFile=true
    ExpertMode=true
    Geometry=1912,1519
    LastUsedDirectory=/mount/Data/Datein/Dokumente/Banking/KMyMoney Daten
    LastUsedFile=/mount/Data/Datein/Dokumente/Banking/KMyMoney Daten/KMyMoney Daten.kmy
    LastViewSelected=7
    Show Statusbar=true
    firstTimeRun=false
  '';
in

{
  options.nixos = {
    userEnvironment.config.kmymoney = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kmymoney config.";
      };
    };
  };

  config = lib.mkIf (config.nixos.userEnvironment.config.kmymoney.enable && config.home-manager.users.${config.nixos.system.user.defaultuser.name}.homeManager.applications.office.financial.enable) {
    systemd.services.kmymoneyConfigChecker = {
      description = "Check and create kmymoney config if not present";

      script = ''
        if [ ! -d "${configDir}" ]; then
          mkdir -p "${configDir}"
        fi

        if [ ! -f "${configFile}" ]; then
          echo '${configContent}' > "${configFile}"
        fi

        chown -R ${config.nixos.system.user.defaultuser.name}:users ${configDir}
      '';

      wantedBy = [ "multi-user.target" ];
    };
  };
}
