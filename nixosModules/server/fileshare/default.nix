{ pkgs, lib, config, ... }: 

{ 
  imports = [
    ./samba.nix
    ./webdav.nix
  ];
}
