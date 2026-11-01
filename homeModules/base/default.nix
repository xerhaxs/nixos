{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./bash.nix
    ./btop.nix
    ./git.nix
    ./gpg.nix
    ./persistent.nix
    ./ranger.nix
    ./secrets.nix
    ./ssh.nix
    ./starship.nix
  ];

  options.homeManager = {
    base = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable base modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.enable {
    homeManager.base = {
      bash.enable = true;
      btop.enable = true;
      git.enable = true;
      gpg.enable = true;
      persistent.enable = true;
      ranger.enable = true;
      secrets.enable = true;
      ssh.enable = true;
      starship.enable = true;
    };
  };
}
