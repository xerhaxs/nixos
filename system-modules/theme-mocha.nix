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
    rev = "6c5f9de6ded7ceb2d97051b6b437392332e36e47"; # commit hash or tag
    sha256 = "sha256-TMElu+90/qtk4ipwfoALt7vKxxB9wxW81ZVbTfZI4kA="; #sha256 = lib.fakeSha256;
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
