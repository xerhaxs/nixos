{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Hourly, Back In Time decides by its own timestamp whether a day has passed. The persistent
  # timestamp makes this catch up after the machine was off, the system crontab survives the tmpfs.
  backintimeJobs = lib.concatLists (
    lib.mapAttrsToList (
      user: home:
      let
        backintime = home.homeManager.applications.tools.backintime;
      in
      lib.optional (backintime.enable && backintime.dailyProfile != null)
        "7 * * * * ${user} nice -n 19 ionice -c 3 /etc/profiles/per-user/${user}/bin/backintime --profile-id ${toString backintime.dailyProfile} backup-job > /dev/null 2>&1"
    ) (config.home-manager.users or { })
  );
in

{
  options.nixos = {
    system.cron = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable cron service.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.cron.enable {
    services.cron = {
      enable = true;
      systemCronJobs = backintimeJobs;
    };
  };
}
