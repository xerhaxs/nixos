{ pkgs, lib, config, ... }: 

{ 
  imports = [
    ./docker.nix
    ./kvm.nix
    ./podman.nix
    ./waydroid.nix
  ];
}
