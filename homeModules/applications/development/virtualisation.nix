{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.virtualisation = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Virtualisation GUIs.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.virtualisation.enable {
    home.packages = with pkgs; [
      quickgui
      spice-gtk
      virt-viewer
    ];
  };
}
