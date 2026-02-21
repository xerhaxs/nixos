{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./samba.nix
    ./share.nix
    ./sshfs.nix
    ./webdav.nix
  ];

  options.nixos = {
    server.fileshare = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable fileshare modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fileshare.enable {
    nixos.server.fileshare = {
      samba.enable = true;
      share.enable = true;
      sshfs.enable = true;
      webdav.enable = true;
    };
  };
}
