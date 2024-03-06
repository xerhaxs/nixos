{ config, pkgs, ... }:

{
  services.barrier.client = {
    enable = true;
    enableCrypot = true;
    enableDragDrop = true;
  };
}
