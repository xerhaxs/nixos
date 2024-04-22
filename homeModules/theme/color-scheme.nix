{ config, lib, pkgs, ... }:

let
  catppuccin-base16 = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "base16";
    rev = "master"; # commit hash or tag
    sha256 = ""; #sha256 = lib.fakeSha256;
  };
  frappe = "base16/frappe.yaml";
  latte = "base16/frappe.yaml";
  macchiato = "base16/macchiato.yaml";
  mocha = "base16/mocha.yaml";
in

{
  colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-frappe" (catppuccin-base16/frappe);
  #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-latte" latte;
  #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-macchiato" macchiato;
  #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-mocha" mocha;
}
