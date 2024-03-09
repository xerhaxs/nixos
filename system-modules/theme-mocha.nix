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
    rev = "main"; # commit hash or tag
    sha256 = "sha256-0zoJOTFjQq3gm5i3xCRbyk781kB7BqcWWNrrIkWf2Xk="; #sha256 = lib.fakeSha256;
  };
  mocha-sddm = "src/catppuccin-mocha";
in

{
  boot.loader.grub.theme = catppuccin-grub + "/${mocha-grub}";

  boot.plymouth = {
    enable = true;
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
