{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.shell.tmux = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable tmux.";
      };
    };
  };

  
  config = lib.mkIf config.nixos.base.shell.tmux.enable {
    environment.systemPackages = [
      pkgs.tmux
    ];
    #programs.tmux = {
    #  enable = true;
    #  terminal = "screen-256color";
    #  clock24 = true;
    #  secureSocket = true;
    #};
  };
}