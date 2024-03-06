# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable"; 
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

{
  wallpaper-engine-kde-plugin = pkgs.plasma5Packages.callPackage ./wallpaper-engine-plasma-plugin.nix {
    inherit (pkgs.gst_all_1) gst-libav;
    inherit (pkgs.python3Packages) websockets;
  };
}