{ config, lib, pkgs, ... }:

let
  catppuccin-grub = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "grub";
    rev = "main"; # commit hash or tag
    sha256 = "sha256-e8XFWebd/GyX44WQI06Cx6sOduCZc5z7/YhweVQGMGY="; #sha256 = lib.fakeSha256;
  };
  mocha-grub = "src/catppuccin-mocha-grub-theme";

  catppuccin-sddm = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "a487ae20737d5014ed986cb0e207cc011726a485"; # commit hash or tag
    sha256 = "sha256-SdpkuonPLgCgajW99AzJaR8uvdCPi4MdIxS5eB+Q9WQ="; #sha256 = lib.fakeSha256;
  };
  mocha-sddm = "src/catppuccin-mocha";
in

{
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
      accents = [ "mauve" ];
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
}
