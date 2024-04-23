{ config, lib, pkgs, ... }:

{
  options.nixos = {
    theme.dracula = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable dracula theme.";
      };
    };
  };

  config = lib.mkIf config.nixos.theme.dracula.enable {
    environment.systemPackages = with pkgs; [
      dracula-theme
      dracula-icon-theme
    ];

    boot.plymouth = {
      font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
      themePackages = with pkgs; [
          (catppuccin-plymouth.override {variant = "${config.nixos.theme.theme.catppuccin.flavor}";})
        ];
      theme = "catppccin-"${config.nixos.theme.theme.catppuccin.flavor};
    };
  };
}
