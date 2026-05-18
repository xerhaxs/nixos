{
  config,
  lib,
  pkgs,
  osConfig,
  userName,
  ...
}:

{
  home.packages = with pkgs; [
    backintime
  ];

  home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
    directories = [
      ".local/share/backintime"
    ];
  };
}
