{ config, pkgs, ... }:

{
 environment.systemPackages = with pkgs; [
    # Language support
    python3
  ];
}
