{ config, lib, pkgs, ... }:

{
  imports = [
    ./fediverse
    ./fileshare
    ./home
    ./network
    ./usenet
  ];
}
