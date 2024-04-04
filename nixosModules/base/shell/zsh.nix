{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.shell.zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ZSH.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;
      enableZshIntegration = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [ "main" ];
      };
      vteIntegration = true;
    };

    programs.nix-index.enableZshIntegration = true;
  };
}