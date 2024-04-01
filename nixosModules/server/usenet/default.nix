{ pkgs, lib, config, ... }: 

{ 
  imports = [
    ./lidarr.nix
    ./nzbget.nix
    ./nzbhydra2.nix
    ./radarr.nix
    ./readarr.nix
    ./sonarr.nix
  ];
}
