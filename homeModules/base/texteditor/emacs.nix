{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    base.texteditor.emacs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable emacs.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.texteditor.emacs.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs; # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
      extraConfig = ''
        (setq standard-indent 2)
      '';
    };
  };
}
