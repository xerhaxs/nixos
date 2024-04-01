{ config, lib, pkgs, ... }:

{
  imports = [
    ./desktopEnvironment
    ./displayManager
    ./windowManager
  ];
}
