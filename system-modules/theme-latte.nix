{ config, lib, pkgs, ... }:

let
  catppuccin-grub = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "grub";
    rev = "main"; # commit hash or tag
    sha256 = "sha256-e8XFWebd/GyX44WQI06Cx6sOduCZc5z7/YhweVQGMGY="; #sha256 = lib.fakeSha256;
  };
  latte-grub = "src/catppuccin-latte-grub-theme";

  catppuccin-sddm = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "a487ae20737d5014ed986cb0e207cc011726a485"; # commit hash or tag
    sha256 = "sha256-SdpkuonPLgCgajW99AzJaR8uvdCPi4MdIxS5eB+Q9WQ="; #sha256 = lib.fakeSha256;
  };
  latte-sddm = "src/catppuccin-latte";
in

{
  boot.loader.grub.theme = catppuccin-grub + "/${latte-grub}";

  boot.plymouth = {
    enable = true;
    font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
    themePackages = with pkgs; [
      (catppuccin-plymouth.override {variant = "latte";})
    ];
    theme = "catppuccin-latte";
  };

  services.xserver.displayManager.sddm.theme = catppuccin-sddm + "/${latte-sddm}";

  environment.systemPackages = with pkgs; [
    #(catppuccin.override {
    #  accents = [ "mauve" ];
    #  variant = [ "latte" ];
    #})

    (catppuccin-kde.override {
      accents = [ "blue" ];
      flavour = [ "latte" ];
      winDecStyles = [ "modern" ];
    })

    (catppuccin-gtk.override {
      accents = [ "blue" ];
      size = "standard";
      tweaks = [ "rimless" "normal" ]; # You can also specify multiple tweaks here
      variant = "latte";
    })

    #(catppuccin-cursors.override {
    #  dimensions.color = [ "Lavender" ];
    #  dimensions.palette = [ "latte" ];
    #})

    (catppuccin-papirus-folders.override {
      accent = "blue";
      flavor = "latte";
    })
  ];
}
