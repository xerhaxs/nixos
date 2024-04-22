{ config, lib, pkgs, ... }:

{
  options.nixos = {
    theme.catppuccin-mocha = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable catppuccin-mocha.";
      };
    };
  };

  config = lib.mkIf config.nixos.theme.catppuccin-mocha.enable {
    boot.loader.grub.theme = catppuccin-grub + "/${mocha-grub}";

    boot.plymouth = {
      enable = true;
      font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
      themePackages = with pkgs; [
        (catppuccin-plymouth.override {variant = "mocha";})
      ];
      theme = "catppuccin-mocha";
    };

    services.xserver.displayManager.sddm.theme = catppuccin-sddm + "/${mocha-sddm}";

    environment.systemPackages = with pkgs; [
      #(catppuccin.override {
      #  accents = [ "mauve" ];
      #  variant = [ "mocha" ];
      #})

      (catppuccin-kde.override {
        accents = nixos.theme.catppuccin.colorscheme
        flavour = [ "mocha" ];
        winDecStyles = [ "modern" ];
      })

      (catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        tweaks = [ "rimless" "normal" ]; # You can also specify multiple tweaks here
        variant = "mocha";
      })

      #(catppuccin-cursors.override {
      #  dimensions.color = [ "Lavender" ];
      #  dimensions.palette = [ "Mocha" ];
      #})

      (catppuccin-papirus-folders.override {
        accent = "mauve";
        flavor = "mocha";
      })
    ];
  };
}
