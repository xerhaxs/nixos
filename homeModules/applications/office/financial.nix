{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.office.financial = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable financial tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.financial.enable {
    home.packages = with pkgs; [
      bisq2
      monero-gui
      p2pool
      xmrig
    ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".local/share/Bisq2"
      ];
    };
  };
}
