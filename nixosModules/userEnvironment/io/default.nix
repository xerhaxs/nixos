{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./input.nix
    ./printing.nix
  ];

  options.nixos = {
    userEnvironment.io = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable io modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.io.enable {
    nixos.userEnvironment.io = {
      audio.enable = true;
      bluetooth.enable = true;
      input.enable = true;
      printing.enable = true;
    };
  };
}
